Rails.application.routes.draw do

  get :ping, controller: :ping, action: :ping

  namespace :api do
    resources :photos, only: [] do
      member do
        post :tag
        delete "tag/:tag_id", action: :destroy_tag
      end
    end

    resources :organizations do
      get :list, on: :collection

      scope module: :organizations do
        resource :logo do
          get :upload_spec
        end
        resources :members
        resources :addresses
        resources :profiles
        resources :notes
        resources :activities

        resources :photos do
          collection do
            get :upload_spec
          end
        end
        resources :screenshots do
          collection do
            get :upload_spec
          end
        end
        resources :pdfs do
          collection do
            get :upload_spec
          end
        end
      end
    end

    resources :people do
      get :list, on: :collection

      get :primary_photo
      put :primary_photo, action: :set_primary_photo

      scope module: :people do
        resources :activities
        resources :organizations
        resources :addresses
        resources :workplaces
        resources :profiles
        resources :relationships
        resources :notes

        resources :photos do
          collection do
            get :upload_spec
          end
        end
        resources :screenshots do
          collection do
            get :upload_spec
          end
        end
      end
    end

    resources :activities do
      get :list, on: :collection

      get :primary_photo
      put :primary_photo, action: :set_primary_photo

      get :photos_of_person

      scope module: :activities do
        resources :participants
        resources :organizations
        resources :notes

        resources :photos do
          collection do
            get :upload_spec
          end
        end
        resources :screenshots do
          collection do
            get :upload_spec
          end
        end
        resources :videos do
          collection do
            get :upload_spec
          end
        end
      end
    end

    resources :sources do
      scope module: :sources do
        resources :photos do
          collection do
            get :upload_spec
          end
        end
        resources :pdfs do
          collection do
            get :upload_spec
          end
        end
      end
    end
  end

end
