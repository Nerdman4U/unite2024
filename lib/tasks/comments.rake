## Load comments from database and save to file
#
namespace :comments do
  desc "Load comments"
  task load: :environment do
    comments = Comment.all

    data = []
    comments.each do |comment|
      vote = Vote.where(id: comment.vote_id).first
      str = "id: #{comment.id}
name: #{vote.name}
email: #{vote.email}
topic: #{comment.topic}
body: #{comment.body}
created_at: #{comment.created_at}
updated_at: #{comment.updated_at}

"
      data << str
    end

    File.write("comments.txt", data.join("\n"))
  end
end
