# == Schema Information
#
# Table name: directory_links
#
#  id         :bigint           not null, primary key
#  title      :string
#  link       :string
#  desc       :text
#  info       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DirectoryLink < ApplicationRecord

  validates :link, :format => URI::regexp(%w(http https))

  def self.heroku_directory_link
    @heroku_directory_link = DirectoryLink.where(title: 'Heroku (Hosting Service)', link:'https://dashboard.heroku.com/apps/lightningmarineservice/', desc:'(Most important service) Heroku hosts app\'s servers(for both app and search feature), app\'s database, general application status, + more.', info:'IMPORTANT: If you change any of the other services usernames, passwords, or any other credentials related to the running of this application, change them in Heroku!!! Click the link above, then settings(in Heroku), then click \'Reveal Config Vars\'(in Heroku) and edit there. Updates there will be automatically updated within the app and accesible in the \'Application Service Links\' section (Admin Options > Application Service Links )').first_or_create
  end

  def self.gmail_directory_link
    @gmail_directory_link = DirectoryLink.where(title: 'Gmail Account', link:'https://mail.google.com/mail/', desc:'Gmail account that sends app emails, as well as, the email address used in sign in credentials for services providing this applications infastructure.').first_or_create
  end

  def self.name_cheap_directory_link
    @name_cheap_directory_link = DirectoryLink.where(title: 'Name Cheap', link:'https://ap.www.namecheap.com/domains/domaincontrolpanel/lightningmarineservice.com/domain', desc:'Provides this application\'s domain (lightningmarineservice.com) and its status', info:'May ask for identidy verification by sending email to gmail account (LightningMarineServices.app@gmail.com)').first_or_create
  end

  def self.aws_s3_directory_link
    @aws_s3_directory_link =  DirectoryLink.where(title: 'AWS S3 (Photo Storage)', link: 'https://s3.console.aws.amazon.com/s3/buckets/lightningmarineservices', desc:'AWS S3 is where all media uploaded is stored.').first_or_create
  end

  def self.predefined_directory_links
    [heroku_directory_link, gmail_directory_link, name_cheap_directory_link, aws_s3_directory_link ]
  end

  DirectoryLink.predefined_directory_links unless (
    DirectoryLink.heroku_directory_link.present? and
    DirectoryLink.gmail_directory_link.present? and
    DirectoryLink.aws_s3_directory_link.present? and
    DirectoryLink.name_cheap_directory_link.present?
  )

end
