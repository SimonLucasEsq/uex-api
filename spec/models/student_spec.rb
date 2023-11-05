require "rails_helper"

describe Student do
  describe ".update_hours" do
    let(:student) { build(:student) }
    let(:hours) {}
    subject { Student.update_hours(student, hours) }

    context "when hours is less than MAX_HOURS" do
      let(:hours) { Student::MAX_HOURS - 1 }

      it "should update hours" do
        subject

        expect(student.hours).to eq(hours)
      end

      it "should update status to insuficient" do
        subject

        expect(student.status).to eq(:insuficient.to_s)
      end

      context "when student status is submitted" do
        before do
          student.status = :submitted
        end

        it "should not update status" do
          expect { subject }.to_not change { student.status }
        end
      end
    end

    context "when hours is equal to MAX_HOURS" do
      let(:hours) { Student::MAX_HOURS }

      it "should update hours" do
        subject

        expect(student.hours).to eq(hours)
      end

      it "should update status to to_be_submitted" do
        subject

        expect(student.status).to eq(:to_be_submitted.to_s)
      end

      context "when student status is submitted" do
        before do
          student.status = :submitted
        end

        it "should not update status" do
          expect { subject }.to_not change { student.status }
        end
      end
    end

    context "when hours is bigger than MAX_HOURS" do
      let(:hours) { Student::MAX_HOURS + 1 }

      it "should update hours" do
        subject

        expect(student.hours).to eq(hours)
      end

      it "should update status to to_be_submitted" do
        subject

        expect(student.status).to eq(:to_be_submitted.to_s)
      end

      context "when student status is submitted" do
        before do
          student.status = :submitted
        end

        it "should not update status" do
          expect { subject }.to_not change { student.status }
        end
      end
    end
  end
end