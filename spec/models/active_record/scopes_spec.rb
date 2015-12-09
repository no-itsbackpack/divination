require 'spec_helper'

shared_examples_for 'the first before max_id page' do
  it 'returns a default sized array' do
    expect(subject.size).to eq(25)
  end

  it 'returns the appropriate first object' do
    expect(subject.first.name).to eq('user100')
  end
end


shared_examples_for 'blank page' do
  it 'returns an array with size 0' do
    expect(subject.size).to eq(0)
  end
end

shared_examples_for 'before max_id pagination' do
  it 'includes a hash with heys :next_url and next_max_id' do
    expect(subject[:next_url]).to include('max_id=76')
    expect(subject[:next_url].scan('max_id').length).to eq(1)
    expect(subject[:next_max_id]).to eq(76)
  end
end


describe Divination::ActiveRecordExtension do
  it 'returns no before max_id when there are no records' do
    params = User.page(max_id: 0).pagination('http://example.com')
    expect(params.has_key?(:next_url)).to be_falsey
    expect(params[:next_max_id]).to be_nil
  end
end


describe Divination::ActiveRecordExtension do
  before do
    1.upto(100) {|i| User.create! :name => "user#{'%03d' % i}", :age => (i / 10)}
    1.upto(100) {|i| GemDefinedModel.create! :name => "user#{'%03d' % i}", :age => (i / 10)}
    1.upto(100) {|i| Device.create! :name => "user#{'%03d' % i}", :age => (i / 10)}
  end

  [User, Admin, GemDefinedModel, Device].each do |model_class|
    context "for #{model_class}" do
      describe '#page' do
        context 'page 1 <= max_id' do
          subject { model_class.page(max_id: 101) }
          it_should_behave_like 'the first before max_id page'
        end

        context 'page 2 <= max_id' do
          subject { model_class.page(max_id: 75) }

          it 'returns a default sized array' do
            expect(subject.size).to eq 25
          end

          it 'returns the correctly sorted first object' do
            expect(subject.first.name).to eq('user075')
          end
        end

        context 'page without an argument' do
          subject { model_class.page() }
          it_should_behave_like 'the first before max_id page'
        end

        context 'before max_id page < 0' do
          subject { model_class.page(max_id: 0) }
          it_should_behave_like 'blank page'
        end

        context 'max_id is equal to last item in last page' do
          subject { model_class.page(max_id: 1) }

          it 'returns nil for next_max_id' do
            expect(subject.next_max_id).to be_nil
          end
        end

        context 'before max_id page > max page' do
          subject { model_class.page(before: 1000) }
          it_should_behave_like 'the first before max_id page'
        end

        describe 'ensure #order_values is preserved' do
          subject { model_class.order('id').page() }

          it 'ensures scope is preserved' do
            expect(subject.order_values.uniq).to eq(["#{model_class.table_name}.id desc"])
          end
        end
      end

      describe '#per' do
        context 'default page per 5' do
          subject { model_class.page.per(5) }

          it 'returns array with size 5' do
            expect(subject.size).to eq(5)
          end

          it 'returns the appropriate first object' do
            expect(subject.first.name).to eq('user100')
          end
        end

        context "default page per nil (using default)" do
          subject { model_class.page.per(nil) }

          it 'uses the default per page' do
            expect(subject.size).to eq(25)
          end
        end
      end

      describe '#next_max_id' do
        context 'before max_id 1st page' do
          subject { model_class.page }

          it 'returns the appropriate next_max_id' do
            expect(subject.next_max_id).to eq 76
          end
        end

        context 'before max_id middle page' do
          subject { model_class.page(max_id: 50) }

          it 'returns the appropriate next_max_id' do
            expect(subject.next_max_id).to eq 26
          end
        end
      end

      describe '#pagination' do
        context 'before max_id' do
          subject { model_class.page.pagination('http://example.com') }
          it_should_behave_like 'before max_id pagination'
        end

        context 'before with existing before query param' do
          subject { model_class.page(max_id: 101).pagination('http://example.com?max_id=10') }
          it_should_behave_like 'before max_id pagination'
        end

        context 'before with query params' do
          subject { model_class.page.pagination('http://example.com?a[]=one&a[]=two') }
          it_should_behave_like 'before max_id pagination'
          specify { expect(subject[:next_url]).to include('a[]=one&a[]=two') }
        end
      end
    end
  end
end
