require "rails_helper"

describe Models::UpdateStudentHoursParticipation do
  let(:student_hours) { 5 }
  let!(:student) { create(:student, hours: student_hours) }
  let!(:activity) { create(:activity) }
  let!(:activity_week) { create(:activity_week, activity: activity) }
  let(:participant_hours) { 10 }
  let(:registered_hours) { nil }
  let!(:activity_week_participant) { 
    create(:activity_week_participant,
      activity_week: activity_week,
      participable: student,
      hours: participant_hours,
      registered_hours: registered_hours
    )
  }

  subject { Models::UpdateStudentHoursParticipation.call(activity_week_participant_params) }

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

        context "when participant hour hasn't already been regitered" do
          let(:participant_hours) { 10 }
          let(:registered_hours) { nil }
  
          it "adds hours to student's hours" do
            subject
  
            expect { student.reload }.to change { student.hours }.by(participant_hours)
          end
  
          it "updates registered hours" do
            subject
  
            expect(activity_week_participant.reload.registered_hours).to eq(participant_hours)
          end

          context "when student's hours after save is less than MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS - 2 }
            let(:participant_hours) { 1 }

            it "changes student's status to insuficient" do
              subject

              expect(student.reload.status).to eq(:insuficient.to_s)
            end
          end

          context "when student's hours after save is equal to MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS - 1}
            let(:participant_hours) { 1 }

            it "changes student's status to to_be_submitted" do
              subject

              expect(student.reload.status).to eq(:to_be_submitted.to_s)
            end
          end

          context "when student's hours after destroy is bigger than MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS - 1}
            let(:participant_hours) { 2 }

            it "changes student's status to to_be_submitted" do
              subject

              expect(student.reload.status).to eq(:to_be_submitted.to_s)
            end
          end
        end

        context "when participant's hour has already been regitered" do
          context "when participant's hour is equal to registered_hour" do
            let(:registered_hours) { participant_hours }
            let(:student_hours) { registered_hours }

            it "doesn't change student's hour" do
              subject

              expect { student.reload }.to_not change { student.hours }
            end
          end

          context "when participant's hour is less than registered_hour" do
            let(:registered_hours) { participant_hours + 1 }
            let(:student_hours) { registered_hours }

            it "subtracts registered_hours and then sum participant_hours" do
              subject

              expect(student.reload.hours).to eq(participant_hours)
            end

            it "updates registered hours" do
              subject
    
              expect(activity_week_participant.reload.registered_hours).to eq(participant_hours)
            end
          end

          context "when participant's hour is bigger than registered_hour" do
            let(:registered_hours) { participant_hours - 1 }
            let(:student_hours) { registered_hours }

            it "subtracts registered_hours and then sum participant_hours" do
              subject

              expect(student.reload.hours).to eq(participant_hours)
            end

            it "updates registered hours" do
              subject
    
              expect(activity_week_participant.reload.registered_hours).to eq(participant_hours)
            end
          end

          context "when student's hours after destroy is less than MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS }
            let(:participant_hours) { Student::MAX_HOURS - 1 }
            let(:registered_hours) { student_hours }

            before do
              student.update!(status: :to_be_submitted)
            end

            it "changes student's status to insuficient" do
              subject

              expect(student.reload.status).to eq(:insuficient.to_s)
            end
          end

          context "when student's hours after destroy is equal to MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS - 1}
            let(:participant_hours) { Student::MAX_HOURS + 1 }
            let(:registered_hours) { student_hours}

            before do
              student.update!(status: :to_be_submitted)
            end

            it "doesn't change student's status" do
              subject

              expect { student.reload }.to_not change { student.status }
            end
          end

          context "when student's hours after destroy is bigger than MAX_HOURS" do
            let(:student_hours) { Student::MAX_HOURS }
            let(:participant_hours) { Student::MAX_HOURS + 1 }
            let(:registered_hours) { student_hours}

            before do
              student.update!(status: :to_be_submitted)
            end

            it "doesn't change student's status" do
              subject

              expect { student.reload }.to_not change { student.status }
            end
          end
        end
      end

      context "with new activity_week_participants as param" do
        let(:new_activity_week_participant) { 
          build(:activity_week_participant,
            activity_week: activity_week,
            participable: student,
            hours: participant_hours,
            registered_hours: registered_hours
          )
        }
        let(:activity_week_participant_params) { [new_activity_week_participant] }

        it "adds hours to student's hours" do
          subject

          expect { student.reload }.to change { student.hours }.by(participant_hours)
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
