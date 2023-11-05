require "rails_helper"

describe Models::RemoveStudentHoursParticipation do
  let(:student_hours) { 5 }
  let!(:student) { create(:student, hours: student_hours) }
  let!(:activity) { create(:activity) }
  let!(:activity_week) { create(:activity_week, activity: activity) }
  let(:registered_hours) { student_hours - 2 }
  let(:participant_hours) { registered_hours }
  let!(:activity_week_participant) { 
    create(:activity_week_participant,
      activity_week: activity_week,
      participable: student,
      hours: participant_hours,
      registered_hours: registered_hours
    )
  }

  subject { Models::RemoveStudentHoursParticipation.call(activity_week_participant_params) }

  before do
    allow(activity_week_participant).to receive(:_destroy).and_return(true)
  end

  describe "#call" do
    context "with missing arguments" do
      let(:activity_week_participant_params) { nil }

      it "raises error" do
        expect {subject}.to raise_error(RuntimeError, "Missing activity_week_participants param")
      end
    end

    context "with valid arguments" do
      context "with persisted activity_week_participants as param" do
        let(:activity_week_participant_params) { [activity_week_participant] }

        context "when participant hour has already been regitered" do

          it "subtracts registered_hours to student hours" do
            subject

            expect { student.reload }.to change { student.hours }.by(-registered_hours)
          end

          it "sets insuficient to student's status" do
            subject

            expect(student.reload.status).to eq(:insuficient.to_s)
          end

          context "when participant's hour is different than registered_hour" do
            let(:participant_hours) { registered_hours + 10 }
            it "subtracts registered_hours hours to student's hours" do
              subject

              expect { student.reload }.to change { student.hours }.by(-registered_hours)
            end
          end

          context "when student's hours after destroy is less than MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS }
            let(:registered_hours) { Student::MAX_HOURS }

            before do
              student.update!(status: :to_be_submitted)
            end

            it "changes student's status to insuficient" do
              subject

              expect(student.reload.status).to eq(:insuficient.to_s)
            end
          end

          context "when student hours after destroy is equal to MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS + 1 }
            let(:registered_hours) { 1 }

            before do
              student.update!(status: :to_be_submitted)
            end

            it "doesn't change student's status" do
              subject

              expect { student.reload }.to_not change { student.status }
            end
          end

          context "when student hours after destroy is bigger than MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS + 2 }
            let(:registered_hours) { 1 }

            before do
              student.update!(status: :to_be_submitted)
            end

            it "doesn't change student's status" do
              subject

              expect { student.reload }.to_not change { student.status }
            end
          end
        end

        context "when participant hour hasn't already been regitered" do
          let(:registered_hours) { nil }

          it "doesn't sustract registered_hours to student's hours" do
            subject

            expect { student.reload }.to_not change { student.hours }
          end

          it "doesn't change student's status" do
            subject

            expect { student.reload }.to_not change { student.hours }
          end

          context "when registered_hours is nil but hours is present" do
            let(:participant_hours) { 10 }

            it "doesn't subtract hours to student's hours" do
              subject

              expect { student.reload }.to_not change { student.hours }
            end

            it "doesn't change student's status" do
              subject

              expect { student.reload }.to_not change { student.hours }
            end
          end
        end
      end

      context "with empty activity_week_participants value" do
        let(:activity_week_participant_params) { [] }

        it "raises error" do
          expect { subject }.to_not raise_error
        end
      end
    end
  end
end
