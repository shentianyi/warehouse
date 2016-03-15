# encoding: utf-8

##
# Backup Generated: jiaxuan_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t jiaxuan_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:jiaxuan_backup, 'Description for jiaxuan_backup') do
  ##
  # Archive [Archive]
  #
  # Adding a file or directory (including sub-directories):
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/directory/"
  #
  # Excluding a file or directory (including sub-directories):
  #   archive.exclude "/path/to/an/excluded_file.rb"
  #   archive.exclude "/path/to/an/excluded_directory
  #
  # By default, relative paths will be relative to the directory
  # where `backup perform` is executed, and they will be expanded
  # to the root of the filesystem when added to the archive.
  #
  # If a `root` path is set, relative paths will be relative to the
  # given `root` path and will not be expanded when added to the archive.
  #
  #   archive.root '/path/to/archive/root'
  #



  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name = "vmi_jiaxuandb"
    db.username = "vmi_jiaxuan"
    db.password = "vmi_jiaxuan@"
    db.host = "localhost"
    db.port = 3306
    db.socket = "/var/run/mysqld/mysqld.sock"
  end


  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 500
    # local.keep       = Time.now - 2592000 # Remove all backups older than 1 month.
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_warning           = false
    mail.on_failure           = false

    mail.from                 = "sender@email.com"
    mail.to                   = "receiver@email.com"
    mail.cc                   = "cc@email.com"
    mail.bcc                  = "bcc@email.com"
    mail.reply_to             = "reply_to@email.com"
    mail.address              = "smtp.gmail.com"
    mail.port                 = 587
    mail.domain               = "your.host.name"
    mail.user_name            = "sender@email.com"
    mail.password             = "my_password"
    mail.authentication       = "plain"
    mail.encryption           = :starttls
  end
end
