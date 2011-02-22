Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '0S4UguhudHejNQHf82eKg', 'Orp3V2ZgFhuXTabSrnf5lquksuJuBDUAntciZuFJJrY'
  provider :facebook, 'b266f1ce27909672156de237b223b006', '3ebeca1d2cd5cb5fca8523d6f703ab93'
end