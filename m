Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0698D36FDDC
	for <lists+kvm-ppc@lfdr.de>; Fri, 30 Apr 2021 17:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhD3PgC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 30 Apr 2021 11:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhD3PgB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 30 Apr 2021 11:36:01 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABE0C06138E
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Apr 2021 08:35:11 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id m7so70467288ljp.10
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Apr 2021 08:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zw/V8/6W4skoSH0mSs8cW3qf3BAXRpq8TIlzvcUbh9Y=;
        b=KB8gW36y7USDPOimeqhXInwA40Pnt1d90bk9cbUzrAJc2frJTwsE8DUmYpsixNTY5D
         0VEStw8wvZ8I0IlKf2CJfoljSzTfYWIayX3SvyxM1bomk9H/siwFiNjIEIKFbzohtdgO
         w6vFYnxfHEF3wCnVt6V3YoSITDNsGsa10Pis/sjL+FQpIE58o9XbL+C2P81CYaPhq8Qt
         qj8CGwVy7J+1cUwf/CXA01U/5rkNLcbVSAinzGvr1lHAjjXEfQK4i5hKVhhHHO2QhunW
         aiKrl9b+u8yIOotQlVcCRKukY18jn7e3TOfbROxw1rCaup7aO+V4Nvp132xeshzjhRwg
         DFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zw/V8/6W4skoSH0mSs8cW3qf3BAXRpq8TIlzvcUbh9Y=;
        b=EgOf6E1BUtDG6hLtte/FHjKcjG8BqcGqqgfc64pRx17SI9RNXCzGWM87Ae3ssUpcf/
         FU3pbdlt8dx18ffr1x7JO2cNIon3B0+7ja79HfwwmA72fK2+iBZvuWyj0uC4DlxuZl0j
         aG6X5JKWZ/N567vlugnrEQfDcsMEgfRJHVk1HOeeVWlb3QzQGGfRvIgizW/gLFPeCa7M
         eAYzBqieGYjfqLqLXvNyrYLJlaDJlM8ZVLGr+Hg9UjfCK7xFzMXVGsIIkqUXTa+grdRj
         zhiYx/NmKXzibcPmGznO9psdz8/MEODqdXkMjMk7dXzhpfSseH+kptKMWkblqAdF+eKP
         0Maw==
X-Gm-Message-State: AOAM530NvduSii7ZyE5i6wZNyzFUE60NMcltQ7Jsxded34JMDOcStzEM
        a97Hb4WC+Th8loTH4jIEvXj376c9saNDZeWAHGF5NA==
X-Google-Smtp-Source: ABdhPJx/QRgwRdWJdR4aTn2uakfmtAz6C7OxdhfGIo2oiu582wd/0wprc5qi+RX6OipU6nb2KN0bPjeYB4Dj/CDoOuM=
X-Received: by 2002:a2e:9a0a:: with SMTP id o10mr4294282lji.216.1619796910218;
 Fri, 30 Apr 2021 08:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210429203740.1935629-1-jingzhangos@google.com>
 <20210429203740.1935629-2-jingzhangos@google.com> <87bl9wnfgo.wl-maz@kernel.org>
In-Reply-To: <87bl9wnfgo.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 30 Apr 2021 10:34:58 -0500
Message-ID: <CAAdAUtiMV_cVXPKBBEymNub8qYq-whLdihKG0si4_ALxK=yv6g@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] KVM: stats: Separate common stats from
 architecture specific ones
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Marc,

On Fri, Apr 30, 2021 at 7:07 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 29 Apr 2021 21:37:37 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
>
> > +struct kvm_vm_stat_common {
> > +     ulong remote_tlb_flush;
> > +};
> > +
> > +struct kvm_vcpu_stat_common {
> > +     u64 halt_successful_poll;
> > +     u64 halt_attempted_poll;
> > +     u64 halt_poll_invalid;
> > +     u64 halt_wakeup;
> > +     u64 halt_poll_success_ns;
> > +     u64 halt_poll_fail_ns;
> > +};
>
> Why can't we make everything a u64? Is there anything that really
> needs to be a ulong? On most architectures, they are the same anyway,
> so we might as well bite the bullet.
That's a question I have asked myself many times. It is a little bit annoying
to handle different types for VM and VCPU stats.
This divergence was from the  commit 8a7e75d47b681933, which says
"However vm statistics
 could potentially be updated by multiple vcpus from that vm at a time.
 To avoid the overhead of atomics make all vm statistics ulong such that
 they are 64-bit on 64-bit systems where they can be atomically incremented
 and are 32-bit on 32-bit systems which may not be able to atomically
 increment 64-bit numbers."

I would be very happy if there is a lock-free way to use u64 for VM stats.
Please let me know if anyone has any idea about this.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
