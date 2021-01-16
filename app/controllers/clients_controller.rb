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
      return render json: {mensaje:"Valor no existe en esa fecha"}
    else 
      if request.headers['X-CLIENT'].present?
        Client.create(name: request.headers['X-CLIENT'], request_date: "#{params[:date]}", ufvalue: responsetohash['serie'][0]['valor'] )
        render json: responsetohash['serie'][0]['valor']
      else
        return render json: {mensaje:"falta colocar key = X-CLIENT y en Header su nombre de cliente"}
      end
    end
  end

  def my_requests
    name = params[:name]
    detail = []
    (Client.where(name: name)).each do |consult|
      hash1 = {}
      hash1[:request_date] = consult.request_date
      hash1[:ufvalue] = consult.ufvalue
      hash1[:created_at] = consult.created_at
      detail.push(hash1)
    end
    hash = {"Cantidad de consultas": "#{Client.where(name: name).count}", "Detalle de consultas": "#{detail}"}
    render json: hash
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
