Rails.application.routes.draw do
  resources :applications, param: :application_token, only: [:create, :update, :show] do
    resources :chats, param: :chat_number, only: [:create, :update, :show] do
      resources :messages, param: :message_number, only: [:create, :update, :show] do
        collection do
          get 'search'
        end
      end
    end
  end
end