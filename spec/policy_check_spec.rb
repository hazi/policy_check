# frozen_string_literal: true

RSpec.describe PolicyCheck do
  describe "inline policy" do
    let(:klass) do
      klass = Struct.new(:value)
      klass.class_exec { extend PolicyCheck } # rubocop:disable RSpec/DescribedClass

      klass
    end

    context "when error-free policies defined in block style" do
      let(:instance) do
        klass.class_exec do
          policy :my_policy do
            error("value is not `1`") { value != 1 }
          end
        end

        klass.new(1)
      end

      it "is expected \#{name}? to be true" do
        expect(instance).to be_my_policy
      end

      it "is expected \#{name}_errors to be empty" do
        expect(instance).to have_attributes(my_policy_errors: be_empty)
      end
    end

    context "when there is a policy with errors defined in the block style" do
      let(:instance) do
        klass.class_exec do
          policy :my_policy do
            error("value is not `1`") { value != 1 }
          end
        end

        klass.new(0)
      end

      it "is expected \#{name}? not to be true" do
        expect(instance).not_to be_my_policy
      end

      it "is expected \#{name}_errors have a message" do
        expect(instance).to have_attributes(my_policy_errors: ["value is not `1`"])
      end
    end

    context "when there is a policy with errors defined in the `&:` style" do
      let(:instance) do
        klass.class_exec do
          def is_not_one?
            value != 1
          end

          policy :my_policy do
            error "value is not `1`", &:is_not_one?
          end
        end

        klass.new(0)
      end

      it "is expected \#{name}? not to be true" do
        expect(instance).not_to be_my_policy
      end

      it "is expected \#{name}_errors have a message" do
        expect(instance).to have_attributes(my_policy_errors: ["value is not `1`"])
      end
    end
  end

  describe "Policy class" do
    let(:klass) do
      klass = Class.new
      klass.class_exec { extend PolicyCheck } # rubocop:disable RSpec/DescribedClass

      klass
    end

    let(:instance) do
      klass.class_exec do
        attr_accessor :value

        policy do
          error("value is not `1`") { value != 1 }
        end
      end

      klass.new
    end

    context "when error-free policies defined in block style" do
      let(:instance) do
        klass.class_exec do
          attr_accessor :value

          policy do
            error("value is not `1`") { value != 1 }
          end
        end

        klass.new.tap { _1.value = 1 }
      end

      it "is expected to be valid" do
        expect(instance).to be_valid
      end

      it "is expected not to be invalid" do
        expect(instance).not_to be_invalid
      end

      it "is expected error_messages to be empty" do
        expect(instance).to have_attributes(error_messages: be_empty)
      end
    end

    context "when there is a policy with errors defined in the block style" do
      let(:instance) do
        klass.class_exec do
          attr_accessor :value

          policy do
            error("value is not `1`") { value != 1 }
          end
        end

        klass.new.tap { _1.value = 0 }
      end

      it "is expected not to be valid" do
        expect(instance).not_to be_valid
      end

      it "is expected to be invalid" do
        expect(instance).to be_invalid
      end

      it "is expected error_messages have a message" do
        expect(instance).to have_attributes(error_messages: ["value is not `1`"])
      end
    end

    context "when there is a policy with errors defined in the `&:` style" do
      let(:instance) do
        klass.class_exec do
          attr_accessor :value

          def is_not_one?
            value != 1
          end

          policy do
            error "value is not `1`", &:is_not_one?
          end
        end

        klass.new.tap { _1.value = 0 }
      end

      it "is expected not to be valid" do
        expect(instance).not_to be_valid
      end

      it "is expected to be invalid" do
        expect(instance).to be_invalid
      end

      it "is expected error_messages have a message" do
        expect(instance).to have_attributes(error_messages: ["value is not `1`"])
      end
    end
  end
end
