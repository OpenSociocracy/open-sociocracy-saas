<template>
<div>
  Member Dashboard

 <div>MemberUid:  {{ auth.memberUid }}</div>
 <div>MemberEmail:  {{ auth.memberEmail }}</div>
 <div>Personal Account:  {{ account.personalAccount }}</div>
 <div>Current Account:  {{ account.currentAccount }}</div>
 <div>Accounts:  {{ account.accounts }}</div>
</div>

</template>

<script setup language="ts">

import { useAuthStore } from '../../stores/auth';
import { useAccountStore } from '../../stores/account';
const auth = useAuthStore();
const account = useAccountStore();


</script>
