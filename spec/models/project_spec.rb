# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:members).through(:project_members) }
    it { is_expected.to have_many(:project_members).dependent(:nullify) }
  end

  describe 'Database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end
end
