class Model < ApplicationRecord
  DEFAULT_LICENSES = {
    'apache-2.0' => 'Apache-2.0',
    'mit' => 'MIT',
    'lgpl' => 'LGPL',
    'lgpl-2.1' => 'LGPL-2.1',
    'lgpl-3.0' => 'LGPL-3.0',
    'gpl' => 'GPL',
    'gpl-2.0' => 'GPL-2.0',
    'gpl-3.0' => 'GPL-3.0',
    'afl-3.0' => 'AFL-3.0',
    'ecl-2.0' => 'ECL-2.0',
    'creativeml-openrail-m' => 'CreativeML Open RAIL-M',
    'agpl-3.0' => 'AGPL-3.0',
    'cc' => 'CC',
    'cc0-1.0' => 'CC0 1.0',
    'cc-by-4.0' => 'CC BY 4.0',
    'cc-by-nc-nd-3.0' => 'CC BY-NC-ND 3.0',
    'cc-by-nc-nd-4.0' => 'CC BY-NC-ND 4.0',
    'cc-by-nc-4.0' => 'CC BY-NC 4.0',
    'cc-by-nc-sa-2.0' => 'CC BY-NC-SA 2.0',
    'cc-by-nc-sa-3.0' => 'CC BY-NC-SA 3.0',
    'cc-by-nc-sa-4.0' => 'CC BY-NC-SA 4.0',
    'other' => 'other'
  }

  enum :visibility, { model_public: 'public', model_private: 'private' }, default: :model_private

  belongs_to :owner, polymorphic: true
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :discussions, as: :discussionable, dependent: :destroy

  after_create :sync_created_model_to_starhub_server
  after_destroy :delete_model_from_starhub_server
  after_update :update_starhub_server_model
  before_save :detect_sensitive_content

  validates :name, format: { with: /\A(?=.{2,70}$)(?!.*[_]{2})(?!.*[-]{2})(?!.*[.]{2})[a-zA-Z0-9_.-]+\Z/ }

  validates :name, uniqueness: { scope: [:owner_type, :owner_id], case_sensitive: false }

  def path
    "#{owner.name}/#{name}"
  end

  def as_json options=nil
    {
      id: id,
      name: name,
      nickname: nickname,
      desc: desc,
      visibility: visibility,
      license: license,
      path: path,
      updated_at: updated_at
    }
  end

  private

  def sync_created_model_to_starhub_server
    res = Starhub.api.create_model(creator.name,
                                   name,
                                   owner.name,
                                   nickname,
                                   desc,
                                   { license: license,
                                     private: model_private? })
    raise StarhubError, res.body unless res.success?
  end

  def delete_model_from_starhub_server
    res = Starhub.api.delete_model(owner.name, name)
    raise StarhubError, res.body unless res.success?
  end

  def update_starhub_server_model
    res = Starhub.api.update_model(creator.name,
                                   name,
                                   owner.name,
                                   nickname,
                                   desc,
                                   { private: model_private? })
    raise StarhubError, res.body unless res.success?
  end

  def detect_sensitive_content
    Starhub.api.text_secure_check('nickname_detection', name)
  end
end
