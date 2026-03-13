import { useEffect, useRef } from 'react';

// Global registry for inputs that need keyboard support
type InputUpdateHandler = (newValue: string) => void;
const inputHandlers = new Map<HTMLInputElement | HTMLTextAreaElement, InputUpdateHandler>();

export function registerInputForKeyboard(
  element: HTMLInputElement | HTMLTextAreaElement,
  handler: InputUpdateHandler
) {
  inputHandlers.set(element, handler);
}

export function unregisterInputForKeyboard(element: HTMLInputElement | HTMLTextAreaElement) {
  inputHandlers.delete(element);
}

export function updateInputFromKeyboard(
  element: HTMLInputElement | HTMLTextAreaElement,
  newValue: string
) {
  const handler = inputHandlers.get(element);
  if (handler) {
    handler(newValue);
  }
}

// Hook to register an input for keyboard support
export function useIndicKeyboard<T extends HTMLInputElement | HTMLTextAreaElement>(
  value: string,
  onChange: (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => void
) {
  const ref = useRef<T>(null);

  useEffect(() => {
    const element = ref.current;
    if (!element) return;

    const handler = (newValue: string) => {
      // Create a synthetic event for React
      const syntheticEvent = {
        target: { value: newValue } as any,
        currentTarget: element,
      } as React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>;
      
      // Set the value on the element first
      const nativeSetter = Object.getOwnPropertyDescriptor(
        Object.getPrototypeOf(element),
        'value'
      )?.set;
      if (nativeSetter) {
        nativeSetter.call(element, newValue);
      } else {
        (element as any).value = newValue;
      }
      
      // Call React's onChange
      onChange(syntheticEvent);
    };

    registerInputForKeyboard(element, handler);
    return () => {
      unregisterInputForKeyboard(element);
    };
  }, [onChange]);

  return ref;
}

