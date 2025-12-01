# frozen_string_literal: true

VitalsMonitor::Engine.routes.draw do
  get "/", to: "vitals#index", as: :vitals
  get "/:component", to: "vitals#show", as: :vitals_component, constraints: { component: /postgres|redis|sidekiq/ }
end
