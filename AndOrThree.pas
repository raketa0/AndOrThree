 //Рычков Александр Александрович
 // Паскаль АБС.НЕТ
 {25. Задано   И-ИЛИ   дерево,   соответствующее   некоторому
множеству изделий. Требуется:
   1) найти число изделий,  записанное с помощью этого дерева;
   2) если  число  изделий  больше  N,  организовать  усечение
дерева  в  диалоге  в  порядке  обхода сверху вниз,  спрашивая
пользователя, какие сыновья ИЛИ-вершин отсекать и сообщая, как
при этом сокращается число изделий.
   Если усекаются  все сыновья ИЛИ-вершины,  то отсекается она
сама и все поддерево,  висящее на сыне первой  ИЛИ-вершины  по
пути к корню дерева).
   УКАЗАНИЕ: если  корни   нескольких   поддеревьев   являются
сыновьями   И-вершины,   то   общее   число   элементов  равно
произведению  числа  элементов  поддеревьев,  а   если   корни
поддеревьев  -  сыновья ИЛИ-вершины,  то общее число элементов
находится как сумма числа элементов в поддеревьях.
   Начальное и  конечное  деревья  выдать на экран в наглядном
виде (12).
}

type
Ukazat = ^AndOrThree;
AndOrThree = record
              Left: Ukazat;
              Right: Ukazat;
              Fath: Ukazat;
              root: string;
              val: integer;
              SumProduct: integer;
              AndOr: boolean; // если AND то TRUE. OR то FALSE
              Level: integer;
            end;
var
  input, output: text;
  inputFile, token: string;
  Three: Ukazat;
  sum, i, count: integer;
Procedure FromFile(var F: text; var ro: Ukazat);
Var
  i, m, k, Len, x, j, z, token: integer;
  R, S, L, parametr, tokenStr: string;   {для формирования строки выдачи}
  p, t, kon: Ukazat;
Begin
  While not Eof(F) do
    begin
      ReadLn(F, S);
      k := 0;
      Len := Length(S);
      While S[k+1] = '.' do k := k+1;  
      {k - уровень вершины, начиная с 0}
      x:= 0;
      for i:= k+1 to Len 
      do 
        begin
          if S[i] <> ' '
          then
            x:= x + 1
          else
            break;
        end;
        for i:= x + k + 1 to len
        do
          begin
            if S[i] = '('
            then
              begin
                j:= i + 1;
                while S[j] <> ')'
                 do
                   begin
                     parametr:= parametr + S[j];
                     j:= j + 1;
                   end;
                break;
              end
          end;
        for i:= j to len
        do
          begin
            if S[i] = '('
            then
              begin
                j:= i + 1;
                while S[j] <> ')'
                 do
                   begin
                     tokenStr:= tokenStr + S[j];
                     j:= j + 1;
                   end;
              end;
          end;
      val(tokenStr, token, i);
      tokenStr:= '';
      R := Copy(S, k+1, x);         
      {имя вершины без точек}
      New(kon);
      kon^.root := R;
      kon^.left := nil;
      kon^.right := nil;
      kon^.Level := k;
      kon^.val := token;
      token := 0;
      if parametr = 'and'
      then
        kon^.AndOr := true
      else if parametr = 'or'
      then kon^.AndOr := false;
      parametr:= '';
      if k = 0 then             {нулевой уровень - корень}
        begin
          ro := kon;       {корень - для возврата в вызывающую}
          kon^.fath := nil;
          m := 0;            {уровень предыдущей вершины}
          t := kon;          {указатель на предыдущую вершину }
          continue;
        end;
      if k > m then       {переход на следующий уровень}
        begin
          t^.left := kon;
          kon^.fath := t;
        end
      else                    { k<>0 и k<=m }
        if k = m then     { уровень, как у предыдущей}
          begin
            t^.right := kon;
            kon^.fath := t^.fath;         {отец тот же, что у брата}
          end
        else                  { k < m - подъем по дереву на m-k уровней }
          begin
            p := t;
            For i := 1 to m-k do
               p := p^.fath;
            { p-предыдущая вершина того же уровня }
            kon^.fath := p^.fath; 
            { отец в исходном дереве тот же, что у брата }
            p^.right := kon;
          end;
      m := k;        { запомнили текущий уровень }
      t := kon;      {для работы со следующей вершиной}
    end;              {конец While}
End;

 Procedure ToFile(var t: Ukazat);
{ выдача в файл в порядке сверху вниз }
Var
  j: integer;
  St, andor: string;   { для формирования строки выдачи }
  p: Ukazat;
Begin
  if t <> nil then
    Begin
      if t^.AndOr = true
      then
        andor:= 'and'
      else
        andor:= 'or';
      St := t^.root;   { имя без точек }
      p := t;
      For j := 1 to t^.Level do  { отступ в зависимости от уровня }
        begin
          p := p^.fath;
          St := '.' + St;
        end;
      WriteLn(St,' (', andor,') (', t^.val,')');
      andor:= '';
      ToFile(t^.left);
      ToFile(t^.right);
    end
end;
procedure clearBuffer(Head: Ukazat);
begin
  if Head <> nil
  then
    begin
      Head^.SumProduct:= 0;  
      clearBuffer(Head^.left);
      clearBuffer(Head^.right);
    end
end;
procedure SumtreeTraversal (Head: Ukazat; var sum: integer); //количество деталей
var  
  flag: boolean;
  HeadOne, fathOne: Ukazat;
  kol: integer;
    Begin
      if Head <> nil then
      begin
            SumtreeTraversal(Head^.left, sum);
            SumtreeTraversal(Head^.right, sum);
            if Head^.left <> nil
            then
              begin
                 HeadOne:= Head;
                 Head:= Head^.left;
                 if Head^.Fath^.AndOr
                 then
                   begin
                     if Head^.SumProduct = 0 
                     then
                       Head^.Fath^.SumProduct:= Head^.val
                     else
                       Head^.Fath^.SumProduct:= Head^.SumProduct + Head^.val; 
                     Head:= Head^.right;
                     if Head <> nil
                     then  
                       while (Head <> nil)
                       do
                         begin
                           if Head^.SumProduct = 0
                           then
                             Head^.Fath^.SumProduct:=  Head^.Fath^.SumProduct * Head^.val
                           else 
                             Head^.Fath^.SumProduct:=  Head^.Fath^.SumProduct * Head^.SumProduct;
                           Head:= Head^.right;
                         end;
                      HeadOne^.SumProduct:= HeadOne^.SumProduct + HeadOne^.val; 
                      sum:= HeadOne^.SumProduct;
                   end 
                 else
                     begin
                       while (Head <> nil)
                       do
                         begin
                           if Head^.SumProduct = 0
                           then
                             Head^.Fath^.SumProduct:= Head^.Fath^.SumProduct + Head^.val
                           else
                             Head^.Fath^.SumProduct:= Head^.Fath^.SumProduct + Head^.SumProduct;
                            Head:= Head^.right;
                         end;
                       sum:= HeadOne^.SumProduct;
                     end;
                   end;
        end;
end;

procedure bolinlog(Head: Ukazat;var andor: string);
begin
  if Head^.AndOr = true
      then
        andor:= 'И'
      else
        andor:= 'ИЛИ';
end;

procedure deleteNode(Head: Ukazat; token: string);
var
  HeadOne, HeadTwo: Ukazat;
begin
   if Head <> nil 
   then
      begin
        if (Head^.left <> nil)  and (Head^.left^.root = token)
        then
          begin
            HeadOne:=Head^.left;
            if (HeadOne^.left <> nil) and (HeadOne^.right = nil)
            then
              begin
                HeadOne^.root:= nil;
                HeadOne^.val:= 0;
                HeadOne^.left:= nil;
                HeadOne^.right:= nil;
                dispose(Head^.left);
              end
            else
            if (HeadOne^.right <> nil) and (HeadOne^.left = nil)
            then
              begin
                HeadTwo:= HeadOne^.right;
                HeadOne^.root:= nil;
                HeadOne^.val:= 0;
                HeadOne^.left:= nil;
                HeadOne^.right:= nil;
                dispose(Head^.left);
                Head^.left:= HeadTwo;
              end
            else
            if (HeadOne^.left <> nil) and (HeadOne^.right <> nil)
            then
              begin
                HeadTwo:= HeadOne^.right;
                HeadOne^.root:= nil;
                HeadOne^.val:= 0;
                HeadOne^.left:= nil;
                HeadOne^.right:= nil;
                dispose(Head^.left);
                Head^.left:= HeadTwo;
              end
            else  dispose(Head^.left);
          end
        else 
        if (Head^.right <> nil) and (Head^.right^.root = token)
        then
          begin
              HeadOne:=Head^.right;
              if HeadOne^.right = nil
              then
                begin
                  HeadOne^.root:= nil;
                  HeadOne^.val:= 0;
                  HeadOne^.left:= nil;
                  HeadOne^.right:= nil;
                  dispose(Head^.right);
                end
              else
                begin
                  HeadTwo:= HeadOne^.right;
                  HeadOne^.root:= nil;
                  HeadOne^.val:= 0;
                  HeadOne^.left:= nil;
                  HeadOne^.right:= nil;
                  dispose(Head^.right);
                  Head^.right:= HeadTwo;  
                end;       
          end;
            deleteNode(Head^.left, token);
            deleteNode(Head^.right, token);
      end
end;

procedure TreeTraversal (var Head: Ukazat; var token: string);//обход дерева
var
  HeadOne, HeadTwo: Ukazat;
  j, col: integer;
  andor: string;
  flag: boolean;
  begin
    j:= 1;
    HeadOne:= Head;
    HeadTwo:= Head;
    flag:= true;
    while flag <> false do
    begin
      if Head <> nil then
      begin
        bolinlog(Head, andor);
        writeln(andor,' вершина ', Head^.root);
        writeln('Его сыновья:');
        Head:= Head^.left;
        j:=1;
        while Head <> nil do
          begin
            bolinlog(Head, andor);
            writeln(j,'. ',andor,' вершина ',Head^.root);
            j:= j + 1;
            Head:= Head^.right;
          end;
        writeln('1. Навигация по дереву   2. Усечь дерево    3. Вернутся к началу дерева    4. закончить программу');
        readln(i);
        if i = 1 
        then
          begin
            writeln('К какому сыну перейти?');
            readln(i);
            Head := HeadOne;
            Head:= Head^.left;
            for j:= 1 to i - 1 
            do
              begin
                Head:= Head^.right;
              end;
             if Head^.SumProduct = 0
             then
               begin
                 col:= Head^.val;
               end 
             else
             begin
               clearBuffer(Head);
               SumtreeTraversal (Head, col);
             end;   
          end
        else if i = 2
        then
          begin
            writeln('Какого сына усечь?');
            readln(i);
            Head := HeadOne;
            Head:= Head^.left;
            for j:= 1 to i - 1 
            do
              begin
                Head:= Head^.right;
              end;
             if Head^.SumProduct = 0
             then
               col:= Head^.val
             else
               SumtreeTraversal (Head, col);
             writeln('Если усечь этого сына то будет удалено ', col, ' деталей' );
             writeln('Вы действительно хотите усечь этого сына');
             sum:= 0;
             j:=1;
             writeln(j,' ДА  ', j + 1,' НЕТ');
             readln(j);
             if j = 1
             then
               begin
                 token:= Head^.root;
                 Head:= HeadTwo;
                 deleteNode(Head, token);
                 writeln('Полученное дерево:');
                 sum:= 0;
                 clearBuffer(Head);
                 SumtreeTraversal (Head, sum);
                 ToFile(HeadTwo);
                 writeln('Сумма элементов равно ', sum);
                 Head:= HeadOne;
               end
            else 
            if j = 2
            then 
              begin
                Head:= HeadOne;
                i:= 1;
              end; 
          end
        else if i = 3
        then 
          begin
            Head:= HeadTwo;
            i:= 0;
          end
        else if i = 4
        then
          exit;
     HeadOne:= Head;
     i:= 1;
      end;
    end;
  end;

  begin
    writeln('Введите входной файл');
    readln(inputFile);
    assign(input, inputFile);
    reset(input);
    readln(input, count);
    FromFile(input, Three);
    writeln('Исходное дерево:');
    ToFile(Three);
    writeln();
    SumtreeTraversal (Three, sum);
    writeln('Сумма элементов равно ', sum);
    if count > sum
    then
      begin
        writeln('Полученное дерево:');
        ToFile(Three);
        writeln('Программа завершена')
      end
    else
    begin
      writeln('Необходимо усечь дерево');
      TreeTraversal (Three, token);
    end;
  close(input);
end.