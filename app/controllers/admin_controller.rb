# coding: utf-8

class AdminController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @vote = current_vote

    @slider = Slider.new({
      name: "admin",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "seascape",
        headers: {
          h1: [_("Administration")],
        },
        res: [640,960,1024,1280,1920,2048,3072,4096],
        type: 'jpg',
        default: 640,
        alt: _(UNITE_TITLE),
        decorators: ["headers", "image"]
      }]
    })

  end

  # public: add votes from a file.
  #
  # Modify created_at value so that new votes has created_at value in future.
  def csv
    admin_csv = params[:admin_csv]
    if admin_csv.blank?
      add_flash :error, "Valitse tiedosto ja paina vasta sitten lähetä-nappia"
      render "index"
      return
    end

    service = ActiveStorage::Blob.service
    file = service.download(admin_csv)
    unless file and file.is_a?(String)
      add_flash :error, "Tiedoston lataaminen epäonnistui"
      render "index"
      return
    end

    # Parse and filter csv data
    require "csv"
    data = CSV.parse(file)
    data = filter_csv(data)

    # Add the ip of the admin
    ip = request.env["REMOTE_ADDR"]
    last_created = Vote.last.created_at
    created_at = last_created > Time.now ? last_created : Time.now
    data.each do |vote|
      new_created_at = created_at + ((180*rand).truncate).minutes
      values = {
        name: vote[0].strip,
        email: vote[1].strip,
        country: vote[2].strip,
        ip: ip,
        created_at: new_created_at
      }
      vote = Vote.create(values)
      if vote.valid?
        VoteMailer.sign_up(vote).deliver_later
        created_at = new_created_at
      end
    end

    add_flash :success, "Tiedosto ladattu järjestelmään, kiitos työstäsi ympäristön puolesta!"
    render "index"
  end

  private

  # public: filter csv data to have name, email and country to add vote.
  #
  # old:
  # Data is a list of vote items read from csv. Every vote should have
  # name, email and country in that order.
  def filter_csv(data)
    data.select do |items|
      return false unless items.kind_of?(Array)
      filtered = items.select { |a| !a.blank? }
      # puts "filtered: #{filtered.inspect}"
      filtered && filtered.size === 3
    end
  end

end
