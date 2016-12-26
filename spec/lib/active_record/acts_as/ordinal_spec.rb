require 'spec_helper'

RANDOM_ORDINAL_MAX = 100
# should be > 2 and <= RANDOM_ORDINAL_MAX
TEST_ENTITIES_COUNT = 10
# should be > 1 and <= TEST_ENTITIES_COUNT
TEST_ENTITIES_SCOPE_COUNT = 6

RSpec.describe ActiveRecord::ActsAs::Ordinal do
  describe 'without options' do
    let(:random_ordinal) { Random.new.rand(RANDOM_ORDINAL_MAX) }

    after { Entity.destroy_all }

    describe 'set default values' do
      it 'should create entity with custom ordinal value' do
        entity = Entity.create!(ordinal: random_ordinal)
        expect(entity.ordinal).to eq random_ordinal
      end

      it 'should set default ordinal value to zero with empty entities table' do
        entity = Entity.create!
        expect(entity.ordinal).to eq 0
      end

      it 'should set default ordinal value to incremented max existing ordinal' do
        entities_with_random_ordinal(TEST_ENTITIES_COUNT, RANDOM_ORDINAL_MAX).each(&:save!)

        entities = [Entity.new(ordinal: RANDOM_ORDINAL_MAX + random_ordinal)]
        (TEST_ENTITIES_COUNT).times { entities << Entity.new }
        entities.each(&:save!)

        1.upto(entities.size - 1) { |i| expect(entities[i].ordinal).to eq entities[i - 1].ordinal + 1 }
      end
    end

    it 'should validate ordinal uniqueness' do
      Entity.create!(ordinal: random_ordinal)

      entity_with_different_ordinal = Entity.new(ordinal: random_ordinal + 1)
      expect(entity_with_different_ordinal).to be_truthy

      entity_with_same_ordinal = Entity.new(ordinal: random_ordinal)
      expect(entity_with_same_ordinal.valid?).to be_falsey
    end

    describe 'reordering' do
      context 'without scope' do
        let(:entities) do
          entities = entities_with_random_ordinal(TEST_ENTITIES_COUNT, RANDOM_ORDINAL_MAX)
          entities.each(&:save!)
        end

        let(:entity) { entities.first }

        it "shouldn't change position if ordinal haven't changed" do
          expect { entity.insert_at(entity.ordinal) }.not_to change { entities.map(&:ordinal) }
        end

        context 'new position is now occupied' do
          let(:position_new) { RANDOM_ORDINAL_MAX + random_ordinal }

          it 'should not change other entities if new position is now occupied' do
            expect { entity.insert_at(position_new) }.not_to change { entities.drop(1).map(&:ordinal) }
          end

          it 'should set new position if new position is now occupied' do
            entity.insert_at(position_new)
            expect(entity.ordinal).to eq position_new
          end
        end

        context 'when new position is occupied' do
          let(:sorted_scope) { entities.sort_by { |entity| entity.ordinal } }

          it 'should correctly reorder close entities when entity moved down' do
            scope = sorted_scope.take(2)
            reordered_ids = scope.map(&:id).reverse! + sorted_scope.drop(2).map(&:id)
            scope.first.insert_at(scope.second.ordinal)
            expect(Entity.order(:ordinal).map(&:id)).to eq reordered_ids
          end

          it 'should correctly reorder close entities when entity moved up' do
            scope = sorted_scope.take(2)
            reordered_ids = scope.map(&:id).reverse! + sorted_scope.drop(2).map(&:id)
            scope.second.insert_at(scope.first.ordinal)
            expect(Entity.order(:ordinal).map(&:id)).to eq reordered_ids
          end

          it 'should correctly reorder entities when entity moved down' do
            scope = sorted_scope.take(TEST_ENTITIES_SCOPE_COUNT)
            # [1, 2, 3, 4, 5].rotate => [2, 3, 4, 5, 1]
            reordered_ids =  scope.map(&:id).rotate + sorted_scope.drop(TEST_ENTITIES_SCOPE_COUNT).map(&:id)
            scope.first.insert_at(scope.last.ordinal)
            expect(Entity.order(:ordinal).map(&:id)).to eq reordered_ids
          end

          it 'should correctly reorder entities when entity moved up' do
            scope = sorted_scope.take(TEST_ENTITIES_SCOPE_COUNT)
            # [1, 2, 3, 4, 5].rotate(-1) => [5, 1, 2, 3, 4]
            reordered_ids =  scope.map(&:id).rotate(-1) + sorted_scope.drop(TEST_ENTITIES_SCOPE_COUNT).map(&:id)
            scope.last.insert_at(scope.first.ordinal)
            expect(Entity.order(:ordinal).map(&:id)).to eq reordered_ids
          end
        end
      end

      context 'with scope' do
        let(:entities) do
          entities = entities_with_random_ordinal(TEST_ENTITIES_COUNT, RANDOM_ORDINAL_MAX)
          entities.each(&:save!)
        end

        let(:entity) { entities.first }

        it "shouldn't change position if ordinal haven't changed" do
          expect { entity.insert_at(entity.ordinal, [entity.ordinal]) }
            .not_to change { entities.map(&:ordinal) }
        end

        context 'new position is now occupied' do
          let(:position_new) { RANDOM_ORDINAL_MAX + random_ordinal }

          it 'should not change other entities if new position is now occupied' do
            expect { entity.insert_at(position_new, entity.ordinal) }
              .not_to change { entities.drop(1).map(&:ordinal) }
          end

          it 'should set new position if new position is now occupied' do
            entity.insert_at(position_new, entity.ordinal)
            expect(entity.ordinal).to eq position_new
          end
        end

        context 'when new position is occupied' do
          let(:sorted_scope) { entities.sort_by { |entity| entity.ordinal } }

          it 'should correctly reorder close entities when entity moved down' do
            scope = sorted_scope.take(2)
            reordered_ids = scope.map(&:id).reverse! + sorted_scope.drop(2).map(&:id)
            scope.first.insert_at(scope.second.ordinal, scope.map(&:ordinal))
            expect(Entity.order(:ordinal).map(&:id)).to eq reordered_ids
          end

          it 'should correctly reorder close entities when entity moved up' do
            scope = sorted_scope.take(2)
            reordered_ids = scope.map(&:id).reverse! + sorted_scope.drop(2).map(&:id)
            scope.second.insert_at(scope.first.ordinal, scope.map(&:ordinal))
            expect(Entity.order(:ordinal).map(&:id)).to eq reordered_ids
          end

          it 'should correctly reorder entities when entity moved down' do
            scope = sorted_scope.take(TEST_ENTITIES_SCOPE_COUNT)
            # [1, 2, 3, 4, 5].rotate => [2, 3, 4, 5, 1]
            reordered_ids =  scope.map(&:id).rotate + sorted_scope.drop(TEST_ENTITIES_SCOPE_COUNT).map(&:id)
            scope.first.insert_at(scope.last.ordinal, scope.map(&:ordinal))
            expect(Entity.order(:ordinal).map(&:id)).to eq reordered_ids
          end

          it 'should correctly reorder entities when entity moved up' do
            scope = sorted_scope.take(TEST_ENTITIES_SCOPE_COUNT)
            # [1, 2, 3, 4, 5].rotate(-1) => [5, 1, 2, 3, 4]
            reordered_ids =  scope.map(&:id).rotate(-1) + sorted_scope.drop(TEST_ENTITIES_SCOPE_COUNT).map(&:id)
            scope.last.insert_at(scope.first.ordinal, scope.map(&:ordinal))
            expect(Entity.order(:ordinal).map(&:id)).to eq reordered_ids
          end

          it 'should reorder entities only from scope when entity moved down' do
            entities.shuffle!
            scope = entities.take(TEST_ENTITIES_SCOPE_COUNT).sort_by { |entity| entity.ordinal }
            # [1, 2, 3, 4, 5].rotate => [2, 3, 4, 5, 1]
            reordered_ids =  scope.map(&:id).rotate
            expect { scope.first.insert_at(scope.last.ordinal, scope.map(&:ordinal)) }
              .not_to change { entities.drop(TEST_ENTITIES_SCOPE_COUNT).map(&:ordinal) }
            expect(Entity.where(id: reordered_ids).order(:ordinal).map(&:id)).to eq reordered_ids
          end
        end
      end
    end
  end
end
