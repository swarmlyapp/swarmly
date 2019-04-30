class Mention
    attr_reader :mentionable
    include Rails.application.routes.url_helpers


    def self.all(letters)
      return Mention.none unless letters.present?
      users = User.limit(5).where('username like ?', "#{letters}%").compact
      users.map do |user|
        { name: user.username }
      end
    end
  
    def self.create_from_text(comment)
      potential_matches = comment.description.scan(/@\w+/i)
      potential_matches.uniq.map do |match|
        mention = Mention.create_from_match(match)
        next unless mention
        comment.update_attributes!(description: mention.markdown_string(comment.description))
        mention
      end.compact
    end

    def self.create_from_match(match)
      user = User.find_by(username: match.delete('@'))
      UserMention.new(user) if user.present?
    end
  
    def initialize(mentionable)
      @mentionable = mentionable
    end
  
    class UserMention < Mention
      def markdown_string(text)
        host = 'https://www.swarmly.app/'
        text.gsub(/@#{mentionable.username}/i,
                  "[**@#{mentionable.username}**](#{user_url(mentionable, host: host)})")
      end 
    end
  end
  