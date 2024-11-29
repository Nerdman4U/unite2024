require "ostruct"
namespace :fix do
  desc "Remove duplicate votes"
  task duplicate_votes: :environment do
    emails = Vote.all.map { |a| [ a.email.downcase, a.id ] }.group_by(&:first)
    to_be_deleted = []
    to_be_saved = []
    emails.each do |k, v|
      if v.size > 1
        to_be_deleted << v[1][1]
        vo = Vote.find_by_id(v[0][1])
        vo.email = vo.email.downcase
        to_be_saved << vo
      end
    end

    if to_be_saved.size != to_be_deleted.size
      puts "to_be_saved.size !== to_be_deleted.size"
      exit
    end

    to_be_saved.each do |vote|
      puts "save #{vote.id}"
      vote.save
    end

    to_be_deleted.each do |id|
      puts "destroy #{id}"
      v = Vote.find_by_id(id)
      v.spam = true
      v.save
    end
  end
end
