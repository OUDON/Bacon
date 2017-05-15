require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    let(:user_first)  { create(:user_without_validate, user_name: 'user1', atcoder_id: 'user1', atcoder_rating: 1000) }
    let(:user_second) { create(:user_without_validate, user_name: 'user2', atcoder_id: 'user2', atcoder_rating: 800) }
    let(:user_third)  { create(:user_without_validate, user_name: 'user3', atcoder_id: 'user3', atcoder_rating: 800) }

    before :each do
      allow(user_first).to  receive(:aoj_solved_count).and_return(10)
      allow(user_second).to receive(:aoj_solved_count).and_return(8)
      allow(user_third).to  receive(:aoj_solved_count).and_return(5)

      sign_in user_first
    end

    it "assigns users to @users" do
      get :index
      expect(assigns(:users)).to eq [user_first, user_second, user_third]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
