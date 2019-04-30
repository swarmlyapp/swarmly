class VotesController < ApplicationController

  def up_vote
    update_vote(1)
  end

  def down_vote
    update_vote(-1)
  end

  private

  def update_vote(new_value)
    @note = Note.find(params[:note_id])
    @vote = @note.votes.where(user: current_user).first

    if @vote
      @vote.update_attribute(:value, new_value)
    else
      @vote = current_user.votes.create(value: new_value, note: @note)
    end

    respond_to do |f|
      f.html
      f.js
    end
  end
end
