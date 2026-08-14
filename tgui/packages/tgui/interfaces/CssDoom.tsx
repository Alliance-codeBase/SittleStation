import { Window } from '../layouts';

export const CssDoom = (props, context) => {
  return (
    <Window
      title="DOOM"
      width={800}
      height={600}
      resizable={true}
    >
      <iframe
        src="https://cssdoom.wtf"
        sandbox="allow-scripts allow-same-origin allow-pointer-lock allow-popups allow-popups-to-escape-sandbox allow-forms allow-modals"
        style={{
          width: '100%',
          height: '100%',
          border: 'none',
          background: '#000',
        }}
      />
    </Window>
  );
};
