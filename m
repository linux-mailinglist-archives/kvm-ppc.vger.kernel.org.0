Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7091F4D193C
	for <lists+kvm-ppc@lfdr.de>; Tue,  8 Mar 2022 14:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346873AbiCHNfH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 8 Mar 2022 08:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCHNfH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 8 Mar 2022 08:35:07 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F20E46162
        for <kvm-ppc@vger.kernel.org>; Tue,  8 Mar 2022 05:34:10 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4KCbrw40Snz9sSV;
        Tue,  8 Mar 2022 14:34:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pOSLpkbXNC81; Tue,  8 Mar 2022 14:34:08 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4KCbrw3F0vz9sSR;
        Tue,  8 Mar 2022 14:34:08 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5FBC78B779;
        Tue,  8 Mar 2022 14:34:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Umgn5pm1SMA9; Tue,  8 Mar 2022 14:34:08 +0100 (CET)
Received: from [192.168.202.9] (unknown [192.168.202.9])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D77528B763;
        Tue,  8 Mar 2022 14:34:07 +0100 (CET)
Message-ID: <f5ec9d55-bac3-b571-dfad-bd501cd364b3@csgroup.eu>
Date:   Tue, 8 Mar 2022 14:34:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH 2/2] KVM: PPC: Book3S HV: Provide a more accurate
 MAX_VCPU_ID in P9
Content-Language: fr-FR
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, groug@kaod.org,
        david@gibson.dropbear.id.au
References: <20210412222656.3466987-1-farosas@linux.ibm.com>
 <20210412222656.3466987-3-farosas@linux.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20210412222656.3466987-3-farosas@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



Le 13/04/2021 à 00:26, Fabiano Rosas a écrit :
> The KVM_CAP_MAX_VCPU_ID capability was added by commit 0b1b1dfd52a6
> ("kvm: introduce KVM_MAX_VCPU_ID") to allow for vcpu ids larger than
> KVM_MAX_VCPU in powerpc.
> 
> For a P9 host we depend on the guest VSMT value to know what is the
> maximum number of vcpu id we can support:
> 
> kvmppc_core_vcpu_create_hv:
>      (...)
>      if (cpu_has_feature(CPU_FTR_ARCH_300)) {
> -->         if (id >= (KVM_MAX_VCPUS * kvm->arch.emul_smt_mode)) {
>                      pr_devel("KVM: VCPU ID too high\n");
>                      core = KVM_MAX_VCORES;
>              } else {
>                      BUG_ON(kvm->arch.smt_mode != 1);
>                      core = kvmppc_pack_vcpu_id(kvm, id);
>              }
>      } else {
>              core = id / kvm->arch.smt_mode;
>      }
> 
> which means that the value being returned by the capability today for
> a given guest is potentially way larger than what we actually support:
> 
> \#define KVM_MAX_VCPU_ID (MAX_SMT_THREADS * KVM_MAX_VCORES)
> 
> If the capability is queried before userspace enables the
> KVM_CAP_PPC_SMT ioctl there is not much we can do, but if the emulated
> smt mode is already known we could provide a more accurate value.
> 
> The only practical effect of this change today is to make the
> kvm_create_max_vcpus test pass for powerpc. The QEMU spapr machine has
> a lower max vcpu than what KVM allows so even KVM_MAX_VCPU is not
> reached.
> 
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>

This patch won't apply after commit a1c42ddedf35 ("kvm: rename 
KVM_MAX_VCPU_ID to KVM_MAX_VCPU_IDS")

Feel free to resubmit if still applicable.

Christsophe


> 
> ---
> I see that for ppc, QEMU uses the capability after enabling
> KVM_CAP_PPC_SMT, so we could change QEMU to issue the check extension
> on the vm fd so that it would get the more accurate value.
> ---
>   arch/powerpc/kvm/powerpc.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index a2a68a958fa0..95c9f47cc1b3 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -649,7 +649,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = KVM_MAX_VCPUS;
>   		break;
>   	case KVM_CAP_MAX_VCPU_ID:
> -		r = KVM_MAX_VCPU_ID;
> +		if (hv_enabled && cpu_has_feature(CPU_FTR_ARCH_300))
> +			r = KVM_MAX_VCPUS * ((kvm) ? kvm->arch.emul_smt_mode : 1);
> +		else
> +			r = KVM_MAX_VCPU_ID;
>   		break;
>   #ifdef CONFIG_PPC_BOOK3S_64
>   	case KVM_CAP_PPC_GET_SMMU_INFO:
