namespace :mercadopago do
  desc "Test MercadoPago preference creation"
  task create_preference: :environment do
    require 'mercadopago'

    sdk = Mercadopago::SDK.new(ENV['MERCADOPAGO_ACCESS_TOKEN'])

    preference_data = {
      items: [
        {
          title: "Test Item",
          unit_price: 100,
          quantity: 1,
          currency_id: 'CLP'
        }
      ],
      payer: {
        name: "Test",
        surname: "User",
        email: "test@example.com"
      },
      back_urls: {
        success: "https://solvify-app-9441069b05b4.herokuapp.com/success",
        failure: "https://solvify-app-9441069b05b4.herokuapp.com/failure",
        pending: "https://solvify-app-9441069b05b4.herokuapp.com/pending"
      },
      auto_return: 'approved'
    }

    begin
      preference_response = sdk.preference.create(preference_data)
      preference = preference_response[:response]

      if preference && preference['id']
        puts "Preference created successfully: #{preference['id']}"
      else
        puts "Error creating MercadoPago preference: #{preference_response.inspect}"
      end
    rescue StandardError => e
      puts "Exception creating MercadoPago preference: #{e.message}"
    end
  end
end
