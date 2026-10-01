with Ada.Text_IO; use Ada.Text_IO;

procedure Producer_Consumer is

   Buffer_Size        : constant Positive := 5;
   Num_Producers      : constant Positive := 3;
   Num_Consumers      : constant Positive := 2;
   Items_Per_Producer : constant Positive := 5;
   Total_Items        : constant Positive := Num_Producers * Items_Per_Producer;

   type Buffer_Data is array (1 .. Buffer_Size) of Integer;

   protected type Bounded_Buffer is
      entry Put (Item : in  Integer);
      entry Get (Item : out Integer);
   private
      Data  : Buffer_Data;
      Head  : Positive := 1;
      Tail  : Positive := 1;
      Count : Natural  := 0;
   end Bounded_Buffer;

   protected body Bounded_Buffer is
      entry Put (Item : in Integer) when Count < Buffer_Size is
      begin
         Data (Tail) := Item;
         Tail := (Tail mod Buffer_Size) + 1;
         Count := Count + 1;
      end Put;

      entry Get (Item : out Integer) when Count > 0 is
      begin
         Item := Data (Head);
         Head := (Head mod Buffer_Size) + 1;
         Count := Count - 1;
      end Get;
   end Bounded_Buffer;

   protected type Counter is
      procedure Decrement (Done : out Boolean);
   private
      Remaining : Natural := Total_Items;
   end Counter;

   protected body Counter is
      procedure Decrement (Done : out Boolean) is
      begin
         Remaining := Remaining - 1;
         Done := (Remaining = 0);
      end Decrement;
   end Counter;

   Shared_Buffer  : Bounded_Buffer;
   Shared_Counter : Counter;

   task type Producer_Task (Id : Positive);
   task body Producer_Task is
   begin
      for I in 1 .. Items_Per_Producer loop
         Shared_Buffer.Put (Id * 100 + I);
         delay 0.05;
      end loop;
   end Producer_Task;

   task type Consumer_Task (Id : Positive);
   task body Consumer_Task is
      Done : Boolean := False;
      Item : Integer;
   begin
      loop
         Shared_Buffer.Get (Item);
         Put_Line ("Consumer" & Integer'Image (Id)
                   & " got" & Integer'Image (Item));
         delay 0.1;
         Shared_Counter.Decrement (Done);
         exit when Done;
      end loop;
   end Consumer_Task;

   -- Access-типы для массивов задач с дискриминантами
   type Producer_Access is access Producer_Task;
   type Consumer_Access is access Consumer_Task;

   Producers : array (1 .. Num_Producers) of Producer_Access;
   Consumers : array (1 .. Num_Consumers) of Consumer_Access;

begin
   Put_Line ("=== Producer-Consumer (buffer size ="
             & Integer'Image (Buffer_Size) & ") ===");

   -- Создаём задачи динамически с передачей дискриминанта
   for I in 1 .. Num_Producers loop
      Producers (I) := new Producer_Task (I);
   end loop;
   for I in 1 .. Num_Consumers loop
      Consumers (I) := new Consumer_Task (I);
   end loop;
end Producer_Consumer;