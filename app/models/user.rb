require 'openssl'

class User < ApplicationRecord
  # Параметры работы модуля шифрования паролей
  ITERATIONS = 2000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions

  validates :email, email_format: { message: 'Invalid email format' }
  validates :username,
            uniqueness: true,
            presence: true,
            length: { maximum: 40 }
  validates :username, format: { with: /\A(?=.* )[^0-9`!@#\\\$%\^&*\;+=]{4,}\z/ }

  attr_accessor :password
  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password

  def encrypt_password
    if password.present?

      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
          OpenSSL::PKCS5.pbkdf2_hmac(
              password, password_salt, ITERATIONS, DIGEST.length, DIGEST
          )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    # Сперва находим кандидата по email
    user = find_by(email: email)

    # Если пользователь не найдет, возвращаем nil
    return nil unless user.present?

    # Формируем хэш пароля из того, что передали в метод
    hashed_password = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
            password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
    )
    # Обратите внимание: сравнивается password_hash, а оригинальный пароль так
    # никогда и не сохраняется нигде. Если пароли совпали, возвращаем
    # пользователя.
    return user if user.password_hash == hashed_password
    # Иначе, возвращаем nil
    nil
  end
end
