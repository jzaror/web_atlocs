class LocationMailer < ApplicationMailer
  default from: "AtLocs <contacto@atlocs.com>"
  layout 'mailer'

  def new_location(location)
    @location = location
    mail(to: Conf.value('admin_email'), subject: 'Solicitud de nueva locación')
  end
end
