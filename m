Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C24A161646
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Feb 2020 16:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgBQPfM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Feb 2020 10:35:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48375 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728873AbgBQPfL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 Feb 2020 10:35:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581953710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I94s+/OW2nmFtGVziJ+53lmgRDQEQNRHpvcvNRvPjFg=;
        b=Uz9oWtwLYuCDLZQ6pGFOwN47vY9HVwUFSrs6OYzi17EliHIAvWEJWBDXU1KnnqjO1Qgo8T
        xrYTr6NuHPWYBLmDFbiTNRdofkeKrdz5UTRmOqt1AeUJToSUKMZX/PXsQPC5dX8XgqEG6Y
        mQ3yUoLOOyZgdugMWOqPRGFoIGSfsRg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-p0RwvB_5Mwa4niCXIggE9A-1; Mon, 17 Feb 2020 10:35:08 -0500
X-MC-Unique: p0RwvB_5Mwa4niCXIggE9A-1
Received: by mail-wm1-f70.google.com with SMTP id g26so6370647wmk.6
        for <kvm-ppc@vger.kernel.org>; Mon, 17 Feb 2020 07:35:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=I94s+/OW2nmFtGVziJ+53lmgRDQEQNRHpvcvNRvPjFg=;
        b=RlZ2VjmejuS4eWdRIRRvtaKJjI5ns7t2UCTVgSaOs5vA0QjVjWf4Mf25Gpkar4K7Jx
         idVXcuxl/3os9MFWxAHxTqxWpUnwshG3XR9EcfzSNifEE9rT7VPGz1/qHFXvE3O4UXY2
         xFqSr6OCuoi87sL5017ABgeL8bL74qqgo/GydCX8RIT8bld/qLidynyOIM+Q47iJkgyF
         W2fBuq+Lwm7+W7fUkJ8t1E0ph4bPOu2NIzmAP6lI8Xmvcg4Ie7CzqHwNvkBY32K1Ou8h
         xXwUB/MIJXfifNz8Doy+xAb0+US3hnBeTpc64bOEztZF1xcipaVjOnwzHiQWvbx1Zt2s
         woQg==
X-Gm-Message-State: APjAAAUjfX374PdX1OpADyjXhUB01/Yj//U4rSJ59Q4oaXy4JHQ4Ltan
        9jFHYeNNKBX65F+eBwMVwNqXQ3ChfzjRC2FQLojF/a5BlSNegSF7N4j7RHPSCl4pljrQFSP1dOl
        C5S1shW8F44MbO/jDhw==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr22883695wmj.150.1581953707737;
        Mon, 17 Feb 2020 07:35:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqw70CrrrSfMwVWl7qnn5bAkrGx2tWvnt4qyiyI0/zrMUKDzlnUG9J1tN9btzikV0/JwRnl8xw==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr22883657wmj.150.1581953707447;
        Mon, 17 Feb 2020 07:35:07 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y8sm1018221wma.10.2020.02.17.07.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 07:35:06 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic dirty log functions
In-Reply-To: <20200207194532.GK2401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com> <20200121223157.15263-16-sean.j.christopherson@intel.com> <20200206200200.GC700495@xz-x1> <20200206212120.GF13067@linux.intel.com> <20200206214106.GG700495@xz-x1> <20200207194532.GK2401@linux.intel.com>
Date:   Mon, 17 Feb 2020 16:35:05 +0100
Message-ID: <87v9o59qhi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> +Vitaly for HyperV
>
> On Thu, Feb 06, 2020 at 04:41:06PM -0500, Peter Xu wrote:
>> On Thu, Feb 06, 2020 at 01:21:20PM -0800, Sean Christopherson wrote:
>> > On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
>> > > But that matters to this patch because if MIPS can use
>> > > kvm_flush_remote_tlbs(), then we probably don't need this
>> > > arch-specific hook any more and we can directly call
>> > > kvm_flush_remote_tlbs() after sync dirty log when flush==true.
>> > 
>> > Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
>> > that prevents calling kvm_flush_remote_tlbs() directly, but I have no
>> > clue as to the important of that code.
>> 
>> As said above I think the x86 lockdep is really not necessary, then
>> considering MIPS could be the only one that will use the new hook
>> introduced in this patch...  Shall we figure that out first?
>
> So I prepped a follow-up patch to make kvm_arch_dirty_log_tlb_flush() a
> MIPS-only hook and use kvm_flush_remote_tlbs() directly for arm and x86,
> but then I realized x86 *has* a hook to do a precise remote TLB flush.
> There's even an existing kvm_flush_remote_tlbs_with_address() call on a
> memslot, i.e. this exact scenario.  So arguably, x86 should be using the
> more precise flush and should keep kvm_arch_dirty_log_tlb_flush().
>
> But, the hook is only used when KVM is running as an L1 on top of HyperV,
> and I assume dirty logging isn't used much, if at all, for L1 KVM on
> HyperV?

(Sorry for the delayed reply, was traveling last week)

When KVM runs as an L1 on top of Hyper-V it uses eVMCS by default and
eVMCSv1 doesn't support PML. I've also just checked Hyper-V 2019 and it
hides SECONDARY_EXEC_ENABLE_PML from guests (this was expected).

>
> I see three options:
>
>   1. Make kvm_arch_dirty_log_tlb_flush() MIPS-only and call
>      kvm_flush_remote_tlbs() directly for arm and x86.  Add comments to
>      explain when an arch should implement kvm_arch_dirty_log_tlb_flush().
>
>   2. Change x86 to use kvm_flush_remote_tlbs_with_address() when flushing
>      a memslot after the dirty log is grabbed by userspace.
>
>   3. Keep the resulting code as is, but add a comment in x86's
>      kvm_arch_dirty_log_tlb_flush() to explain why it uses
>      kvm_flush_remote_tlbs() instead of the with_address() variant.
>
> I strongly prefer to (2) or (3), but I'll defer to Vitaly as to which of
> those is preferable.

I'd vote for (2): while this will effectively be kvm_flush_remote_tlbs()
for now, we may think of something smarter in the future (e.g. PV
interface for KVM-on-KVM).

>
> I don't like (1) because (a) it requires more lines code (well comments),
> to explain why kvm_flush_remote_tlbs() is the default, and (b) it would
> require even more comments, which would be x86-specific in generic KVM,
> to explain why x86 doesn't use its with_address() flush, or we'd lost that
> info altogether.
>

-- 
Vitaly

