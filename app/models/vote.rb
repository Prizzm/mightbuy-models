class Vote < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  validates  :topic, presence: true

  has_many :timeline_events, as: :subject, dependent: :destroy

  fires :new_vote, on: :create, actor: :user, secondary_subject: :topic

  def self.update_user(vote_id, user)
    updated = false

    if vote_id && vote = Vote.find_by_id(vote_id)
      if existing_vote = Vote.find_by_topic_id_and_user_id(vote.topic.id, user.id)
        vote.destroy
        vote = existing_vote
        updated = vote.update_attributes(buyit: vote.buyit)
      else
        updated = vote.update_attributes(user_id: user.id)
      end

      vote.send_notifications if updated
    end

    updated
  end

  def like_dislike_text
    buyit ? 'liked' : 'did not like'
  end

  def activity_line(timeline_event)
    actor,topic = timeline_event.actor, timeline_event.secondary_subject
    return nil if(!actor || !topic)

    owner_link =
      if topic.user
        "<a href='/users/#{topic.user.to_param}'>#{topic.user.name}'s</a>"
      else
        "Anonymous's"
      end

    "#{actor.name} #{like_dislike_text} #{owner_link} <a href='/topics/#{topic.to_param}'>#{topic.subject.first(45)}..</a> on mightbuy.".html_safe
  end

  def send_notifications
    Delayed::Job.enqueue( ::VotesMailerJob.new(self.id) )
  end
end
