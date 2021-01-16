class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update, :destroy]

  # GET /clients
  def index
    @clients = Client.all

    render json: @clients
  end

  # GET /clients/1
  def show
    render json: @client
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client, status: :created, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      render json: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
  end

  #bring the UF value
  def uf
    api_url = "https://mindicador.cl/api/uf/#{(params[:date])}"
    response = HTTParty.get(api_url)
    responsetohash = JSON.parse(response.read_body)
    if responsetohash['serie'][0].nil?
      'fecha no existe'
    elsif request.headers['X-CLIENT'].present?
      Client.create(name: name, request_date: "#{params[:date]}", ufvalue: responsetohash['serie'][0]['valor'] )
      render json: responsetohash['serie'][0]['valor']
    else
        render json: 'falta colocar key = X-CLIENT y en Header su nombre de cliente'
    end
  end

  def my_requests
    name = params[:name]
    render json: Client.where(name: name)
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:name, :request_date, :ufvalue)
    end
end
