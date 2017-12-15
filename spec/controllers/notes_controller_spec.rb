require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  let(:need) { create(:need) }

  describe '#create' do
    it 'creates an activity item for the note' do
      post :create, params: { need_id: need, note: { body: 'This is a note' } }

      expect(controller.send(:note)).to be_persisted
      expect(controller.send(:note).item_type).to eq('note')
    end

    it 'redirects to the need activity page' do
      post :create, params: { need_id: need, note: { body: 'This is a note' } }

      expect(controller).to redirect_to(activity_need_path(controller.send(:need).id))
    end

    it 'redirects to the need activity page with an error given an invalid note' do
      post :create, params: { need_id: need, note: { body: '' } }

      expect(controller).to redirect_to(activity_need_path(controller.send(:need).id))
      expect(controller.flash.alert).to be_present
    end
  end

end
