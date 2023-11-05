require "rails_helper"

describe Api::ActivityWeeksController, type: :controller do
  let(:activity_week) { create(:activity_week) }
  let(:student) { create(:student, hours: 10) }
  let!(:activity_week_participant) { 
    create(:activity_week_participant,
      activity_week: activity_week,
      participable: student,
      hours: student.hours,
      registered_hours: student.hours
    )
  }
  let(:activity_week_participants_attributes) {
    [
      {
        id: activity_week_participant.id,
        hours: activity_week_participant.hours + 1
      }
    ]
  }
  let(:activity_week_params) {
    {
      start_date: activity_week.start_date + 1.day,
      end_date: activity_week.end_date + 1.day,
      activity_week_participants: activity_week_participants_attributes
    }
  }

  before do
    login
  end

  describe "#update" do
    before do
      expect(Models::UpdateActivityWeekServices).to receive(:call).and_call_original

      put :update, params: { id: activity_week.id, activity_week: activity_week_params }
    end

    context "when resource is found" do
      it { is_expected.to respond_with :ok }

      it "should create activity week participants" do
        subject
        activity_week.reload
        student.reload

        expect(activity_week.start_date).to eq(activity_week_params[:start_date])
        expect(activity_week.end_date).to eq(activity_week_params[:end_date])
        expect(student.hours).to eq(activity_week_participants_attributes.first[:hours])
      end

      it "returns result message" do
        response_body = JSON.parse(response.body)["activity_week"]
        activity_week.reload

        expect(response_body).to be_present
        expect(response_body["start_date"]).to eq(I18n.l(activity_week.start_date, format: :default))
        expect(response_body["end_date"]).to eq(I18n.l(activity_week.end_date, format: :default))
      end

      context "when failed to update resource" do
        let(:activity_week_params) {
          {
            start_date: nil
          }
        }

        it { is_expected.to respond_with(:unprocessable_entity) }

        it "respods with error message" do
          errors = JSON.parse(response.body)["errors"]

          expect(errors["start_date"]).to eq(["no puede estar en blanco"])
        end
      end
    end

    context "with invalid param" do
      xit { is_expected.to respond_with :bad_request }
    end

    context "when resource is not found" do
      before do
        put :update, params: { id: -1, activity_week: activity_week_params }
      end

      it { is_expected.to respond_with :not_found }
    end
  end
end
