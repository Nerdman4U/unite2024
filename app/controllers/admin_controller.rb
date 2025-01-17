# coding: utf-8

class AdminController < ApplicationController
  def index # admin
    if params[:admin_hash] != Rails.application.config.x.admin_hash
      redirect_to :root
      nil
    end
  end

  # Add votes from file
  #
  # Modify created_at value so that new votes has created_at value in future.
  def upload # admin_upload
    if params[:admin_hash] != Rails.application.config.x.admin_hash
      redirect_to :root
      return
    end

    admin_csv = params[:admin_csv]
    if admin_csv.blank?
      add_flash :error, "Valitse tiedosto ja paina vasta sitten lähetä-nappia"
      render "index"
      return
    end

    # Parse and filter csv data
    require "csv"
    data = CSV.parse(admin_csv.read)
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
