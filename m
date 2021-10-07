Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6036E425482
	for <lists+kvm-ppc@lfdr.de>; Thu,  7 Oct 2021 15:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241608AbhJGNrM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 7 Oct 2021 09:47:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241197AbhJGNrL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 7 Oct 2021 09:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633614317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6usspG94A1kNlqd/WFrWFDCc16P7tAqSAi+n+Gy8zoU=;
        b=JljdMGOo7E0/vxc0zmUW1Si13ii92oiuGtCr7zPsYZYcs2KLRgBJcyOfs6LD6G3uNq81GW
        ATZ1RiuwEfCAgCw2ciT4tjEVzvm8EVaUfpBsW0EmazXUBYJ0EegzP6BwqkBzr5hXyipHlz
        HNXabuiwL8XsblUICuik7du4DjacDAA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-WalsVxMiO7y2qpELv1IsDA-1; Thu, 07 Oct 2021 09:45:16 -0400
X-MC-Unique: WalsVxMiO7y2qpELv1IsDA-1
Received: by mail-wr1-f69.google.com with SMTP id d13-20020adfa34d000000b00160aa1cc5f1so4730579wrb.14
        for <kvm-ppc@vger.kernel.org>; Thu, 07 Oct 2021 06:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6usspG94A1kNlqd/WFrWFDCc16P7tAqSAi+n+Gy8zoU=;
        b=lF+6cMHUL/pIs3trIPJmwtrLMsCzmmsZ1LMbB55ugECPiKZBH3dO+lS2xPwEyOzRT6
         jToMdD9KFBKzL7VQGvN37wlFjrAqMQsxk4Xnigv9uSY1RKntMRBxqbSP732A4UqNKJ0n
         Fg4hWEeNvuT8l4gAvlmmF+rsLIWDoSxyq0sMcetv3PmenDsJknQTCe/xAk+gXkfBuyWe
         PW5lPC1RH+Qg3qzb+SKxj/qN762bWGvymWTTCQ/e7vKz/aRA/IZNwYC1nPcED4oPyuAh
         J5PZfT1IAI+LJPS1WWtGlwLUTNgYKciOJViUhWyDRtA6VscQk7llkJArrHMXCBjNrMI2
         jPLw==
X-Gm-Message-State: AOAM531WGYjzWPdkbWliLlIqSJ7e7683dmOparNLeUeB1Zf1Jy8702Td
        ZvGNFsSGoVCLZ5od9Po6jvbJzMMEbiNXZk3YiRs/LGJ3Z4sO04K3GXeeCf94Ftt967t/LLNvMQC
        TREK7KhApdbcxupEq4A==
X-Received: by 2002:adf:bb08:: with SMTP id r8mr5750698wrg.222.1633614315038;
        Thu, 07 Oct 2021 06:45:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5grJqb2V1AulhcQfdWUkwxLsq/AzMT1s5kA3HVmlm1/7Jko50u59wnpZfc6iu0gGMemasiQ==
X-Received: by 2002:adf:bb08:: with SMTP id r8mr5750665wrg.222.1633614314742;
        Thu, 07 Oct 2021 06:45:14 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.3.114])
        by smtp.gmail.com with ESMTPSA id a81sm1300665wmd.30.2021.10.07.06.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 06:45:14 -0700 (PDT)
Message-ID: <1bc32339-b786-99bd-d49c-ad19ac7ce29b@redhat.com>
Date:   Thu, 7 Oct 2021 15:45:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: PPC: Defer vtime accounting 'til after IRQ handling
Content-Language: en-US
To:     Greg Kurz <groug@kaod.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
References: <20211006073745.82109-1-lvivier@redhat.com>
 <20211006124204.4741bb5c@bahia.huguette>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20211006124204.4741bb5c@bahia.huguette>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 06/10/2021 12:42, Greg Kurz wrote:
> On Wed,  6 Oct 2021 09:37:45 +0200
> Laurent Vivier <lvivier@redhat.com> wrote:
> 
>> Commit 61bd0f66ff92 has moved guest_enter() out of the interrupt
>> protected area to be able to have updated tick counters, but
>> commit 112665286d08 moved back to this area to avoid wrong
>> context warning (or worse).
>>
>> None of them are correct, to fix the problem port to POWER
>> the x86 fix 160457140187 ("KVM: x86: Defer vtime accounting 'til
>> after IRQ handling"):
>>
>> "Defer the call to account guest time until after servicing any IRQ(s)
>>   that happened in the guest or immediately after VM-Exit.  Tick-based
>>   accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
>>   handler runs, and IRQs are blocked throughout the main sequence of
>>   vcpu_enter_guest(), including the call into vendor code to actually
>>   enter and exit the guest."
>>
>> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2009312
>> Fixes: 61bd0f66ff92 ("KVM: PPC: Book3S HV: Fix guest time accounting with VIRT_CPU_ACCOUNTING_GEN")
> 
> This patch was merged in linux 4.16 and thus is on the 4.16.y
> stable branch and it was backported to stable 4.14.y. It would
> make sense to Cc: stable # v4.14 also, but...
> 
>> Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
> 
> ... this one, which was merged in linux 5.12, was never backported
> anywhere because it wasn't considered as a fix, as commented here:
> 
> https://lore.kernel.org/linuxppc-dev/1610793296.fjhomer31g.astroid@bobo.none/
> 
> AFAICT commit 61bd0f66ff92 was never mentioned anywhere in a bug. The
> first Fixes: tag thus looks a bit misleading. I'd personally drop it
> and Cc: stable # v5.12.
>

Ok, I update the comment.

>> Cc: npiggin@gmail.com
>>
>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>> ---
>>   arch/powerpc/kvm/book3s_hv.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 2acb1c96cfaf..43e1ce853785 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -3695,6 +3695,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
>>   
>>   	srcu_read_unlock(&vc->kvm->srcu, srcu_idx);
>>   
>> +	context_tracking_guest_exit();
>> +
>>   	set_irq_happened(trap);
>>   
>>   	spin_lock(&vc->lock);
>> @@ -3726,9 +3728,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
>>   
>>   	kvmppc_set_host_core(pcpu);
>>   
>> -	guest_exit_irqoff();
>> -
> 
> 
> Change looks ok but it might be a bit confusing for the
> occasional reader that guest_enter_irqoff() isn't matched
> by a guest_exit_irqoff().
> 
>>   	local_irq_enable();
>> +	vtime_account_guest_exit();
>>   
> 
> Maybe add a comment like in x86 ?
> 

done

>>   	/* Let secondaries go back to the offline loop */
>>   	for (i = 0; i < controlled_threads; ++i) {
>> @@ -4506,13 +4507,14 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>>   
>>   	srcu_read_unlock(&kvm->srcu, srcu_idx);
>>   
>> +	context_tracking_guest_exit();
>> +
>>   	set_irq_happened(trap);
>>   
>>   	kvmppc_set_host_core(pcpu);
>>   
>> -	guest_exit_irqoff();
>> -
>>   	local_irq_enable();
>> +	vtime_account_guest_exit();
>>   
>>   	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
>>   
> 
> Same remarks. FWIW a followup was immediately added to x86 to
> encapsulate the enter/exit logic in common helpers :
> 
> ommit bc908e091b3264672889162733020048901021fb
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Tue May 4 17:27:35 2021 -0700
> 
>      KVM: x86: Consolidate guest enter/exit logic to common helpers
> 
> This makes the code nicer. Maybe do something similar for POWER ?

I don't like to modify kernel code when it's not needed. I just want to fix a bug, if 
someone wants this nicer I let this to him...

Thanks,
Laurent

