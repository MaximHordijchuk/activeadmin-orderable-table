(function($) {
    $(document).ready(function() {
        var $handle = $('activeadmin-orderable-handle');
        if ($handle.length > 0) {
            $handle.closest('tbody').activeAdminOrderable();
        }
    });

    $.fn.activeAdminOrderable = function() {
        var $container = this;

        // Returns all sibling elements between $firstElement and $lastElement
        // including these elements
        var findElements = function ($container, $firstElement, $lastElement) {
            var $elements = $firstElement.nextUntil($lastElement);
            var elements = [$firstElement[0]];
            for (var i = 0; i < $elements.length; i++) {
                elements.push($elements[i]);
            }
            elements.push($lastElement[0]);
            return elements;
        };

        // [1, 2, 3, 4, 5] -> [2, 3, 4, 5, 1]
        // Reverse: [1, 2, 3, 4, 5] -> [5, 1, 2, 3, 4]
        var rotateArray = function (elements, reverse) {
            var result = [], i;
            if (reverse) {
                result.push(elements[elements.length - 1]);
                for (i = 0; i < elements.length - 1; i++) {
                    result.push(elements[i]);
                }
            } else {
                for (i = 1; i < elements.length; i++) {
                    result.push(elements[i]);
                }
                result.push(elements[0]);
            }
            return result;
        };

        // Returns array of elements' ordinal values
        var getOrdinals = function (elements) {
            var ordinals = [];
            for (var i = 0; i < elements.length; i++) {
                ordinals.push($(elements[i]).find('[data-ordinal]').data('ordinal'));
            }
            return ordinals;
        };

        var setOrdinals = function (elements, ordinals) {
            for (var i = 0; i < elements.length; i++) {
                $(elements[i]).find('[data-ordinal]').data('ordinal', ordinals[i]);
            }
        };

        var sendReorderRequest = function ($element, ordinals) {
            var url = $element.find('[data-reorder-url]').data('reorder-url');
            $.ajax({
                url: url,
                type: 'post',
                data: { position: $element.find('[data-ordinal]').data('ordinal'),
                        ordinals: ordinals },
                error: function(error) { console.log('Reordering failed:', error) }
            });
        };

        var logOrdinals = function (elements) {
            for (var i = 0; i < elements.length; i++) {
                console.log($(elements[i]).find('[data-ordinal]').data('ordinal'));
            }
        };

        Sortable.create($container[0], {
            animation: 150,
            draggable: 'tr',
            onEnd: function (event) {
                if (event.oldIndex != event.newIndex) {
                    var $firstElement, $lastElement, $movedElement, elements, ordinals;
                    if (event.oldIndex < event.newIndex) { // from left to right
                        $firstElement = $container.find('tr').eq(event.oldIndex);
                        $lastElement = $container.find('tr').eq(event.newIndex);
                        $movedElement = $lastElement
                    } else { // from right to left
                        $firstElement = $container.find('tr').eq(event.newIndex);
                        $lastElement = $container.find('tr').eq(event.oldIndex);
                        $movedElement = $firstElement
                    }
                    elements = findElements($container, $firstElement, $lastElement);
                    ordinals = rotateArray(getOrdinals(elements), event.oldIndex < event.newIndex);
                    setOrdinals(elements, ordinals);
                    sendReorderRequest($movedElement, ordinals);
                }
            }
        });
    }
})(jQuery);
