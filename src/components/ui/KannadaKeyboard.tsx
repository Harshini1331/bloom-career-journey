import { useState, useEffect, useRef } from 'react';
import type React from 'react';
import { X, Keyboard } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { updateInputFromKeyboard, registerInputForKeyboard } from '@/hooks/useKannadaKeyboard';

interface KannadaKeyboardProps {
  targetInputId?: string;
  targetElement?: HTMLInputElement | HTMLTextAreaElement | null;
  onInput?: (char: string) => void;
  // Support English UI plus Kannada + Tamil input
  lang?: 'en' | 'kn' | 'ta';
}

// Kannada script layout - closer to Google Inscript style (grouped for familiarity)
// Includes independent vowels, common vowel signs, and grouped consonants.
const KANNADA_LAYOUT = {
  // Independent vowels
  vowels: ['ಅ', 'ಆ', 'ಇ', 'ಈ', 'ಉ', 'ಊ', 'ಋ', 'ಎ', 'ಏ', 'ಐ', 'ಒ', 'ಓ', 'ಔ'],
  // Vowel signs and virama (used after consonants)
  row1: ['ಾ', 'ಿ', 'ೀ', 'ು', 'ೂ', 'ೃ', 'ೆ', 'ೇ', 'ೈ', 'ೊ', 'ೋ', 'ೌ', '್'],
  // Consonants grouped broadly like Inscript rows
  row2: ['ಕ', 'ಖ', 'ಗ', 'ಘ', 'ಙ', 'ಚ', 'ಛ', 'ಜ', 'ಝ', 'ಞ'],
  row3: ['ಟ', 'ಠ', 'ಡ', 'ಢ', 'ಣ', 'ತ', 'ಥ', 'ದ', 'ಧ', 'ನ'],
  row4: ['ಪ', 'ಫ', 'ಬ', 'ಭ', 'ಮ', 'ಯ', 'ರ', 'ಲ', 'ವ'],
  row5: ['ಶ', 'ಷ', 'ಸ', 'ಹ', 'ಳ', 'ೞ', 'ಱ'],
  row6: [] as string[],
  row7: [] as string[],
  numbers: ['೦', '೧', '೨', '೩', '೪', '೫', '೬', '೭', '೮', '೯'],
};

// Tamil script layout – approximates Google Tamil99 / INSCRIPT groupings
// Shows independent vowels, common vowel signs, and grouped consonants.
const TAMIL_LAYOUT = {
  // Independent vowels
  vowels: ['அ', 'ஆ', 'இ', 'ஈ', 'உ', 'ஊ', 'எ', 'ஏ', 'ஐ', 'ஒ', 'ஓ', 'ஔ'],
  // Vowel signs and pulli
  row1: ['ா', 'ி', 'ீ', 'ு', 'ூ', 'ெ', 'ே', 'ை', 'ொ', 'ோ', 'ௌ', '்', 'ஃ'],
  // Core consonants – first row
  row2: ['க', 'ங', 'ச', 'ஞ', 'ட', 'ண', 'த', 'ந', 'ப', 'ம'],
  // Second row of consonants
  row3: ['ய', 'ர', 'ல', 'வ', 'ழ', 'ள', 'ற', 'ன'],
  // Additional consonants used in loanwords
  row4: ['ஜ', 'ஷ', 'ஸ', 'ஹ'],
  row5: [] as string[],
  row6: [] as string[],
  row7: [] as string[],
  // Hide dedicated number row for Tamil keyboard to avoid extra yellow strip
  numbers: [] as string[],
};

export function KannadaKeyboard({ targetInputId, targetElement, onInput, lang = 'en' }: KannadaKeyboardProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [isShift, setIsShift] = useState(false);
  const keyboardRef = useRef<HTMLDivElement>(null);
  const lastFocusedElementRef = useRef<HTMLInputElement | HTMLTextAreaElement | null>(null);

  // Only show when a supported Indian language is active
  if (lang !== 'kn' && lang !== 'ta') return null;

  const isKannada = lang === 'kn';
  const layout = isKannada ? KANNADA_LAYOUT : TAMIL_LAYOUT;

  const insertChar = (char: string) => {
    console.log('🔹 Keyboard: insertChar called with:', char);
    
    let element = targetElement;
    
    // Method 1: Use explicitly provided element
    if (!element && targetInputId) {
      element = document.getElementById(targetInputId) as HTMLInputElement | HTMLTextAreaElement | null;
      console.log('🔍 Keyboard: Tried targetInputId:', targetInputId, 'Found:', !!element);
    }
    
    // Method 2: Use stored last focused element
    if (!element) {
      element = lastFocusedElementRef.current;
      console.log('🔍 Keyboard: Using last focused element:', !!element);
    }
    
    // Method 3: Find currently focused input/textarea
    if (!element) {
      const focused = document.activeElement;
      if (focused && (focused.tagName === 'TEXTAREA' || focused.tagName === 'INPUT')) {
        element = focused as HTMLInputElement | HTMLTextAreaElement;
        lastFocusedElementRef.current = element;
        console.log('🔍 Keyboard: Found active element:', element.tagName, element.id || element.className);
      }
    }
    
    // Method 4: Search for the most recently focused input/textarea in the document
    // This is a fallback when focus is lost
    if (!element) {
      // Find all textarea/input elements with lang="kn"/"ta" or inside [lang="kn"/"ta"]
      // Using descendant selector to find inputs anywhere inside lang containers
      const allInputs = document.querySelectorAll(
        'textarea[lang="kn"], input[lang="kn"], [lang="kn"] textarea, [lang="kn"] input,' +
        'textarea[lang="ta"], input[lang="ta"], [lang="ta"] textarea, [lang="ta"] input,' +
        'textarea:not([readonly]), input:not([readonly])'
      );
      console.log('🔍 Keyboard: Searching DOM for inputs, found:', allInputs.length);
      
      if (allInputs.length > 0) {
        // Try to find one that's visible and not disabled
        for (let i = 0; i < allInputs.length; i++) {
          const input = allInputs[i] as HTMLInputElement | HTMLTextAreaElement;
          if (input.offsetParent !== null && !input.disabled && !input.readOnly) {
            element = input;
            lastFocusedElementRef.current = element;
            console.log('✅ Keyboard: Found input via DOM search:', element.tagName, element.id || element.className);
            break;
          }
        }
        
        // If still not found, use the first one
        if (!element && allInputs.length > 0) {
          element = allInputs[0] as HTMLInputElement | HTMLTextAreaElement;
          lastFocusedElementRef.current = element;
          console.log('✅ Keyboard: Using first found input:', element.tagName);
        }
      }
    }
    
    if (!element) {
      console.warn('⚠️ Keyboard: No input element found');
      console.warn('⚠️ Keyboard: activeElement:', document.activeElement?.tagName);
      console.warn('⚠️ Keyboard: lastFocusedElement:', lastFocusedElementRef.current?.tagName);
      return;
    }
    
    console.log('✅ Keyboard: Found element:', element.tagName, element.id || element.className);
    
    const start = element.selectionStart || 0;
    const end = element.selectionEnd || 0;
    const currentValue = element.value || '';
    const newValue = currentValue.slice(0, start) + char + currentValue.slice(end);
    
    console.log('📝 Keyboard: Current value:', currentValue, 'New value:', newValue, 'Selection:', start, '-', end);
    
    // Step 1: Set value using native setter (bypasses React's controlled check)
    const nativeInputValueSetter = Object.getOwnPropertyDescriptor(
      Object.getPrototypeOf(element),
      'value'
    )?.set;
    
    if (nativeInputValueSetter) {
      nativeInputValueSetter.call(element, newValue);
      console.log('✅ Keyboard: Set value via native setter');
    } else {
      (element as any).value = newValue;
      console.log('✅ Keyboard: Set value directly');
    }
    
    // Step 2: Create proper input event that React will catch
    // React uses event delegation and listens for 'input' events
    let inputEvent: InputEvent;
    try {
      inputEvent = new InputEvent('input', {
        bubbles: true,
        cancelable: true,
        composed: true,
        inputType: 'insertText',
        data: char,
        isTrusted: false,
      });
      console.log('✅ Keyboard: Created InputEvent');
    } catch (e) {
      // Fallback for browsers that don't support InputEvent constructor
      inputEvent = document.createEvent('InputEvent') as InputEvent;
      inputEvent.initEvent('input', true, true);
      console.log('✅ Keyboard: Created InputEvent via initEvent');
    }
    
    // Step 3: Try multiple methods to trigger React's onChange
    
    // Method A: Find React Fiber node and call onChange directly
    let handlerFound = false;
    try {
      // React 18 uses __reactFiber$<random> or __reactInternalInstance$<random>
      const allKeys = Object.keys(element);
      const reactKeys = allKeys.filter(key => 
        key.startsWith('__reactFiber') || 
        key.startsWith('__reactInternalInstance') ||
        key.startsWith('__reactContainereNode') ||
        key.includes('reactFiber') ||
        key.includes('reactInternal')
      );
      
      console.log('🔍 Keyboard: Found React keys:', reactKeys.length, reactKeys.slice(0, 3));
      
      for (const reactKey of reactKeys) {
        try {
          const fiberNode = (element as any)[reactKey];
          if (!fiberNode) continue;
          
          console.log('🔍 Keyboard: Traversing Fiber tree for key:', reactKey);
          
          // Walk up the fiber tree to find onChange
          let currentFiber = fiberNode;
          let depth = 0;
          const maxDepth = 20;
          
          while (currentFiber && depth < maxDepth) {
            // Check multiple prop locations
            const fiberProps = 
              currentFiber.memoizedProps || 
              currentFiber.pendingProps || 
              currentFiber.props ||
              currentFiber.memoizedState?.memoizedProps;
            
            if (fiberProps && fiberProps.onChange) {
              console.log('🎯 Keyboard: Found onChange at depth', depth, 'in', reactKey);
              
              // Create proper React ChangeEvent
              const eventTarget = {
                value: newValue,
                tagName: element.tagName,
                type: element.type,
                name: element.name,
                id: element.id,
              };
              
              // Ensure target has all properties React might access
              Object.setPrototypeOf(eventTarget, element);
              
              const syntheticEvent = {
                target: eventTarget,
                currentTarget: element,
                bubbles: true,
                cancelable: true,
                defaultPrevented: false,
                eventPhase: 2,
                isTrusted: false,
                nativeEvent: inputEvent,
                preventDefault: () => {},
                isDefaultPrevented: () => false,
                stopPropagation: () => {},
                persist: () => {},
                timeStamp: Date.now(),
                type: 'change',
              } as React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>;
              
              // Ensure target.value is correct
              Object.defineProperty(eventTarget, 'value', {
                value: newValue,
                writable: true,
                enumerable: true,
                configurable: true,
              });
              
              try {
                console.log('🚀 Keyboard: Calling onChange handler');
                fiberProps.onChange(syntheticEvent);
                console.log('✅ Keyboard: onChange called successfully');
                handlerFound = true;
                break;
              } catch (e) {
                console.error('❌ Keyboard: Error calling onChange:', e);
              }
            }
            
            // Move up the fiber tree
            currentFiber = currentFiber.return || currentFiber._debugOwner || currentFiber.return?.return;
            depth++;
          }
          
          if (handlerFound) break;
        } catch (e) {
          console.warn('⚠️ Keyboard: Error accessing Fiber:', e);
        }
      }
    } catch (e) {
      console.warn('⚠️ Keyboard: Error in Fiber traversal:', e);
    }
    
    // Method B: Try registered handler
    if (!handlerFound) {
      try {
        updateInputFromKeyboard(element, newValue);
        console.log('✅ Keyboard: Used registered handler');
        handlerFound = true;
      } catch (e) {
        console.warn('⚠️ Keyboard: Registered handler not found');
      }
    }
    
    // Method C: Dispatch native events (React should catch via event delegation)
    if (!handlerFound) {
      console.log('📡 Keyboard: Dispatching native events');
      
      // Dispatch input event
      const inputDispatched = element.dispatchEvent(inputEvent);
      console.log('📡 Keyboard: InputEvent dispatched:', inputDispatched);
      
      // Also dispatch change event
      const changeEvent = new Event('change', { 
        bubbles: true, 
        cancelable: true 
      });
      const changeDispatched = element.dispatchEvent(changeEvent);
      console.log('📡 Keyboard: ChangeEvent dispatched:', changeDispatched);
      
      // Dispatch on document level (where React listens)
      if (document.activeElement === element) {
        document.dispatchEvent(inputEvent);
        console.log('📡 Keyboard: Dispatched to document level');
      }
    }
    
    // Step 4: Update cursor position
    const newPos = start + char.length;
    requestAnimationFrame(() => {
      try {
        element.setSelectionRange(newPos, newPos);
        element.focus();
        console.log('✅ Keyboard: Cursor updated to position', newPos);
      } catch (e) {
        console.warn('⚠️ Keyboard: Error updating cursor:', e);
      }
    });
    
    // Callback if provided
    if (onInput) onInput(char);
    
    console.log('🏁 Keyboard: insertChar complete. Handler found:', handlerFound);
  };

  const handleBackspace = () => {
    let element = targetElement;
    if (!element && targetInputId) {
      element = document.getElementById(targetInputId) as HTMLInputElement | HTMLTextAreaElement | null;
    }
    
    if (!element) {
      const focused = document.activeElement;
      if (focused && (focused.tagName === 'TEXTAREA' || focused.tagName === 'INPUT')) {
        element = focused as HTMLInputElement | HTMLTextAreaElement;
      }
    }
    
    if (element) {
      const start = element.selectionStart || 0;
      const end = element.selectionEnd || 0;
      const value = element.value || '';
      let newValue = value;
      let newPos = start;
      
      if (start === end && start > 0) {
        newValue = value.slice(0, start - 1) + value.slice(start);
        newPos = start - 1;
      } else if (start !== end) {
        newValue = value.slice(0, start) + value.slice(end);
        newPos = start;
      }
      
      const nativeInputValueSetter = Object.getOwnPropertyDescriptor(
        window.HTMLInputElement?.prototype || window.HTMLTextAreaElement?.prototype,
        'value'
      )?.set;
      if (nativeInputValueSetter) {
        nativeInputValueSetter.call(element, newValue);
      }
      
      const inputEvent = new Event('input', { bubbles: true });
      element.dispatchEvent(inputEvent);
      const changeEvent = new Event('change', { bubbles: true });
      element.dispatchEvent(changeEvent);
      
      setTimeout(() => {
        element?.setSelectionRange(newPos, newPos);
        element?.focus();
      }, 0);
    }
  };

  const handleSpace = () => insertChar(' ');
  const handleEnter = () => insertChar('\n');
  
  // Helper function to handle keyboard button clicks
  // Prevents blur and re-focuses input
  const handleKeyButtonClick = (char: string) => {
    insertChar(char);
    // Re-focus the input after clicking to keep keyboard open
    setTimeout(() => {
      if (lastFocusedElementRef.current) {
        lastFocusedElementRef.current.focus();
      }
    }, 10);
  };
  
  // Prevent blur when clicking keyboard buttons
  const handleKeyButtonMouseDown = (e: React.MouseEvent<HTMLButtonElement>) => {
    e.preventDefault(); // Prevent losing focus from input
  };
  
  const handleKeyButtonTouchStart = (e: React.TouchEvent<HTMLButtonElement>) => {
    e.preventDefault(); // Prevent losing focus from input
  };

  // Auto-register all inputs/textarea elements for keyboard support
  useEffect(() => {
    const registerInputs = () => {
      const inputs = document.querySelectorAll(
        'textarea[lang="kn"], input[lang="kn"], [lang="kn"] textarea, [lang="kn"] input,' +
        'textarea[lang="ta"], input[lang="ta"], [lang="ta"] textarea, [lang="ta"] input'
      );
      inputs.forEach((input) => {
        if (input instanceof HTMLInputElement || input instanceof HTMLTextAreaElement) {
          // Find the onChange handler from React
          const reactKeys = Object.keys(input).filter(key => 
            key.startsWith('__reactFiber') || 
            key.startsWith('__reactInternalInstance')
          );
          
          for (const reactKey of reactKeys) {
            try {
              const fiberNode = (input as any)[reactKey];
              if (!fiberNode) continue;
              
              let currentFiber = fiberNode;
              let depth = 0;
              while (currentFiber && depth < 10) {
                const props = currentFiber.memoizedProps || currentFiber.pendingProps || currentFiber.props;
                if (props?.onChange) {
                  // Register this input with its onChange handler
                  const handler = (newValue: string) => {
                    const nativeSetter = Object.getOwnPropertyDescriptor(
                      Object.getPrototypeOf(input),
                      'value'
                    )?.set;
                    if (nativeSetter) {
                      nativeSetter.call(input, newValue);
                    } else {
                      (input as any).value = newValue;
                    }
                    
                    const syntheticEvent = {
                      target: input,
                      currentTarget: input,
                      bubbles: true,
                      cancelable: true,
                      defaultPrevented: false,
                      eventPhase: 0,
                      isTrusted: false,
                      nativeEvent: {} as Event,
                      preventDefault: () => {},
                      isDefaultPrevented: () => false,
                      stopPropagation: () => {},
                      persist: () => {},
                      timeStamp: Date.now(),
                      type: 'input',
                    };
                    props.onChange(syntheticEvent as any);
                  };
                  
                  registerInputForKeyboard(input, handler);
                  break;
                }
                currentFiber = currentFiber.return || currentFiber._debugOwner;
                depth++;
              }
            } catch (e) {
              // Continue
            }
          }
        }
      });
    };

    // Register inputs initially and on DOM changes
    registerInputs();
    const observer = new MutationObserver(registerInputs);
    observer.observe(document.body, { childList: true, subtree: true });
    
    return () => observer.disconnect();
  }, []);

  // Auto-show keyboard when focus on textarea/input with lang=kn or lang=ta
  useEffect(() => {
    const handleFocus = (e: FocusEvent) => {
      const target = e.target as HTMLElement;
      const isTextInput = target.tagName === 'TEXTAREA' || target.tagName === 'INPUT';
      const hasLangKn = target.getAttribute('lang') === 'kn' || target.closest('[lang="kn"]');
      const hasLangTa = target.getAttribute('lang') === 'ta' || target.closest('[lang="ta"]');
      if (isTextInput && (hasLangKn || hasLangTa)) {
        // Store the focused element for later use
        lastFocusedElementRef.current = target as HTMLInputElement | HTMLTextAreaElement;
        setIsOpen(true);
        console.log('✅ Keyboard: Element focused:', target.tagName, target.id || target.className);
      }
    };

    const handleBlur = (e: FocusEvent) => {
      // Don't clear the ref or close if clicking inside keyboard
      const relatedTarget = e.relatedTarget as Node;
      if (keyboardRef.current?.contains(relatedTarget)) {
        console.log('✅ Keyboard: Blur ignored - clicked inside keyboard');
        return;
      }
      
      // Also check if relatedTarget is a button (keyboard button)
      if (relatedTarget && (relatedTarget as HTMLElement).tagName === 'BUTTON') {
        const button = relatedTarget as HTMLButtonElement;
        // Check if the button is inside the keyboard
        if (keyboardRef.current?.contains(button)) {
          console.log('✅ Keyboard: Blur ignored - clicked keyboard button');
          return;
        }
      }
      
      // Small delay to allow button clicks to register and prevent closing immediately
      setTimeout(() => {
        const activeElement = document.activeElement;
        
        // Don't close if:
        // 1. Active element is inside keyboard
        // 2. Active element is still an input/textarea (user might have clicked another input)
        // 3. Last focused element is still an input/textarea
        const isInsideKeyboard = keyboardRef.current?.contains(activeElement);
        const isInputOrTextarea = activeElement && 
          (activeElement.tagName === 'TEXTAREA' || activeElement.tagName === 'INPUT');
        const hasStoredInput = lastFocusedElementRef.current !== null;
        
        if (isInsideKeyboard || (isInputOrTextarea && hasStoredInput)) {
          console.log('✅ Keyboard: Keeping keyboard open');
          // Update stored element if focus moved to a different input
          if (isInputOrTextarea && activeElement !== lastFocusedElementRef.current) {
            lastFocusedElementRef.current = activeElement as HTMLInputElement | HTMLTextAreaElement;
            console.log('✅ Keyboard: Focus moved to new element:', activeElement.tagName);
          }
          return;
        }
        
        // Only close if focus moved completely away
        console.log('🔒 Keyboard: Closing - focus moved away');
        setIsOpen(false);
      }, 300); // Increased delay to prevent premature closing
    };

    document.addEventListener('focusin', handleFocus);
    document.addEventListener('focusout', handleBlur);
    return () => {
      document.removeEventListener('focusin', handleFocus);
      document.removeEventListener('focusout', handleBlur);
    };
  }, []);

  if (!isOpen) {
    const openLabel =
      lang === 'ta'
        ? 'விசைப்பலகை'
        : 'ಕೀಬೋರ್ಡ್';
    const aria =
      lang === 'ta'
        ? 'Show Tamil Keyboard'
        : 'Show Kannada Keyboard';

    return (
      <Button
        type="button"
        variant="outline"
        size="sm"
        onClick={() => setIsOpen(true)}
        className="fixed bottom-4 right-4 z-40 shadow-lg bg-blue-50 hover:bg-blue-100 border-blue-300"
        aria-label={aria}
      >
        <Keyboard className="w-4 h-4 mr-2" />
        {openLabel}
      </Button>
    );
  }

  return (
    <div
      ref={keyboardRef}
      className="fixed bottom-0 left-0 right-0 z-50 bg-white border-t border-gray-300 shadow-2xl p-2 md:p-4"
      style={{ maxHeight: '40vh', overflowY: 'auto' }}
    >
      <div className="container mx-auto">
        <div className="flex items-center justify-between mb-2">
          <h3 className="text-sm font-semibold text-gray-700">
            {isKannada ? 'ಕನ್ನಡ ಕೀಬೋರ್ಡ್' : 'தமிழ் விசைப்பலகை'}
          </h3>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={() => setIsOpen(false)}
            className="h-6 w-6 p-0"
            aria-label="Close Keyboard"
          >
            <X className="w-4 h-4" />
          </Button>
        </div>

        <div className="space-y-1">
          {/* Vowels */}
          <div className="flex flex-wrap gap-1 justify-center">
            {layout.vowels.map((char) => (
              <button
                key={char}
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                className="px-3 py-2 text-lg font-medium bg-blue-50 hover:bg-blue-100 border border-blue-200 rounded active:bg-blue-200 transition-colors touch-manipulation"
              >
                {char}
              </button>
            ))}
          </div>

          {/* Consonants Row 1 */}
          <div className="flex flex-wrap gap-1 justify-center">
            {layout.row1.map((char) => (
              <button
                key={char}
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                className="px-3 py-2 text-lg font-medium bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded active:bg-gray-200 transition-colors touch-manipulation"
              >
                {char}
              </button>
            ))}
          </div>

          {/* Consonants Row 2 */}
          <div className="flex flex-wrap gap-1 justify-center">
            {layout.row2.map((char) => (
              <button
                key={char}
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                className="px-3 py-2 text-lg font-medium bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded active:bg-gray-200 transition-colors touch-manipulation"
              >
                {char}
              </button>
            ))}
          </div>

          {/* Consonants Row 3 */}
          <div className="flex flex-wrap gap-1 justify-center">
            {layout.row3.map((char) => (
              <button
                key={char}
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                  className="px-3 py-2 text-lg font-medium bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded active:bg-gray-200 transition-colors touch-manipulation"
              >
                {char}
              </button>
            ))}
          </div>

          {/* Consonants Row 4 */}
          <div className="flex flex-wrap gap-1 justify-center">
            {layout.row4.map((char) => (
              <button
                key={char}
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                className="px-3 py-2 text-lg font-medium bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded active:bg-gray-200 transition-colors touch-manipulation"
              >
                {char}
              </button>
            ))}
          </div>

          {/* Consonants Row 5 */}
          <div className="flex flex-wrap gap-1 justify-center">
            {layout.row5.map((char) => (
              <button
                key={char}
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                className="px-3 py-2 text-lg font-medium bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded active:bg-gray-200 transition-colors touch-manipulation"
              >
                {char}
              </button>
            ))}
          </div>

          {/* Consonants Row 6 */}
          <div className="flex flex-wrap gap-1 justify-center">
            {layout.row6.map((char) => (
              <button
                key={char}
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                className="px-3 py-2 text-lg font-medium bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded active:bg-gray-200 transition-colors touch-manipulation"
              >
                {char}
              </button>
            ))}
          </div>

          {/* Consonants Row 7 */}
          <div className="flex flex-wrap gap-1 justify-center">
            {layout.row7.map((char) => (
              <button
                key={char}
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                className="px-3 py-2 text-lg font-medium bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded active:bg-gray-200 transition-colors touch-manipulation"
              >
                {char}
              </button>
            ))}
          </div>

          {/* Numbers and Actions */}
          <div className="flex flex-wrap gap-1 justify-center items-center mt-2">
            <div className="flex flex-wrap gap-1">
              {layout.numbers.map((char) => (
                <button
                  key={char}
                  type="button"
                  onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick(char)}
                  className="px-3 py-2 text-lg font-medium bg-yellow-50 hover:bg-yellow-100 border border-yellow-200 rounded active:bg-yellow-200 transition-colors touch-manipulation"
                >
                  {char}
                </button>
              ))}
            </div>
            <button
              type="button"
              onMouseDown={handleKeyButtonMouseDown}
              onTouchStart={handleKeyButtonTouchStart}
              onClick={() => handleKeyButtonClick(' ')}
              className="px-6 py-2 text-sm font-medium bg-gray-100 hover:bg-gray-200 border border-gray-300 rounded active:bg-gray-300 transition-colors touch-manipulation"
            >
              Space
            </button>
            <button
              type="button"
              onMouseDown={handleKeyButtonMouseDown}
              onTouchStart={handleKeyButtonTouchStart}
              onClick={() => {
                handleBackspace();
                setTimeout(() => {
                  if (lastFocusedElementRef.current) {
                    lastFocusedElementRef.current.focus();
                  }
                }, 10);
              }}
              className="px-4 py-2 text-sm font-medium bg-red-50 hover:bg-red-100 border border-red-200 rounded active:bg-red-200 transition-colors touch-manipulation"
            >
              ⌫
            </button>
            {targetElement?.tagName === 'TEXTAREA' && (
              <button
                type="button"
                onMouseDown={handleKeyButtonMouseDown}
                onTouchStart={handleKeyButtonTouchStart}
                onClick={() => handleKeyButtonClick('\n')}
                className="px-4 py-2 text-sm font-medium bg-green-50 hover:bg-green-100 border border-green-200 rounded active:bg-green-200 transition-colors touch-manipulation"
              >
                ↵ Enter
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

