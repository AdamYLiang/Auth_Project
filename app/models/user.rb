# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }

    after_initialize :ensure_session_token

    has_many :cats,
        foreign_key: :user_id,
        class_name: :Cat
    
    has_many :requests,
        foreign_key: :user_id,
        class_name: :CatRentalRequest

    attr_reader :password

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            return user
        else
            nil
        end
    end

    def reset_session_token!
        self.update!(session_token: self.class.generate_session_token)
        self.session_token
    end

    def password=(value)
        @password = value
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        bcrypted_pw = BCrypt::Password.new(self.password_digest)
        bcrypted_pw.is_password?(password)
    end

    private
    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end


end
