Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E5E445C54
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Nov 2021 23:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhKDWoh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Nov 2021 18:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhKDWoh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Nov 2021 18:44:37 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917B6C061203
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Nov 2021 15:41:58 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e65so6696530pgc.5
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Nov 2021 15:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2cM+pc7RJOlLXf/kESM57DsH9Y+7ss4v2ISlVrw0au4=;
        b=ooE6FbC1dphlseVcXYf6E54FhDQXALDT9cp9rkFbPJ4y3391PeZbY42Xq5zYAiM2X0
         NdOPtJ6lkjBowxQXuPPYzsk/ImWUzRx84xa98kqJsQVBicjU2eDc5DVULiWpqnCKqxed
         Ey2Ctp6iCrEN8zCtRphZ24isIw03JAvk0SfSWM0DA/73Pbf0h/QRbrwYHZfhgAzS25J9
         xoJiSowrT7yhbflDyi/bGTCX/rlcA7okzQ8gpsTNHWowkIpirAi9P+owp8DITCHO+0RI
         qztHqyk6DNOgAHnulQogAsMkvqtleYWLZNf20k/P+g9/YJ3n7yTI2IPueMQnaW5/KaTr
         oILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2cM+pc7RJOlLXf/kESM57DsH9Y+7ss4v2ISlVrw0au4=;
        b=0kqxqLQjK3rMgrpnvYpPA7542TxdpDR5NXeLU2v7JcWhFaAs3sg8udxt02JjgKoLAb
         9YTnr88r+g2/Zt2MiLm/h/xmFQlSFi+PSqfCdWAasUoUFBbowvlRjIPbjz9dV45S9YTJ
         8p+Jhvk4FWqJXwcHBrjasYnwYs5Eib1/Oqpkf/vD5BGxfGJt9IHe26XURFUY5yENJbVi
         3ltRV+IAe1rjMtPThEQyx/2Q0K8Urg+l4ZKf+ict7Ayv05IH5q8PDW2Bj6z5C9DFC3hw
         g6/pGjJkjvX1kHN3yPx8Tk1f55J8ClLnZtWzsqyXYIeo7ngu8XYAEQOzW/HAL4KiE1M5
         7bsA==
X-Gm-Message-State: AOAM532uHzVuERxWlli0Ig9NJEeXFVU0KMuQ1FZ65BC1FW3iJuao4uoA
        NQ4+8bn4uUJGcxxj/vtcBMZfOw==
X-Google-Smtp-Source: ABdhPJxxNMKGv/NhLtIdMl/BRJOCT+zMUUqyt4AWTJHdlm9O9AHyBiNnpE4YQWobAiLulE4sZ0UvKQ==
X-Received: by 2002:a05:6a00:21c2:b0:44c:fa0b:f72 with SMTP id t2-20020a056a0021c200b0044cfa0b0f72mr54948884pfj.13.1636065717795;
        Thu, 04 Nov 2021 15:41:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h2sm4707798pjk.44.2021.11.04.15.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 15:41:57 -0700 (PDT)
Date:   Thu, 4 Nov 2021 22:41:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 01/30] KVM: Ensure local memslot copies operate on
 up-to-date arch-specific data
Message-ID: <YYRhsclZpZwilkE5@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-2-seanjc@google.com>
 <CANgfPd-uuPFjAHk5kVNom2Qs=UU_GX6CQ0xDLg1h_iL8t8S2aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-uuPFjAHk5kVNom2Qs=UU_GX6CQ0xDLg1h_iL8t8S2aQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Nov 04, 2021, Ben Gardon wrote:
> > @@ -1597,6 +1596,26 @@ static int kvm_set_memslot(struct kvm *kvm,
> >                 kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
> >         }
> >
> > +       /*
> > +        * Make a full copy of the old memslot, the pointer will become stale
> > +        * when the memslots are re-sorted by update_memslots(), and the old
> > +        * memslot needs to be referenced after calling update_memslots(), e.g.
> > +        * to free its resources and for arch specific behavior.  This needs to
> > +        * happen *after* (re)acquiring slots_arch_lock.
> > +        */
> > +       slot = id_to_memslot(slots, new->id);
> > +       if (slot) {
> > +               old = *slot;
> > +       } else {
> > +               WARN_ON_ONCE(change != KVM_MR_CREATE);
> > +               memset(&old, 0, sizeof(old));
> > +               old.id = new->id;
> > +               old.as_id = as_id;
> > +       }
> > +
> > +       /* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
> > +       memcpy(&new->arch, &old.arch, sizeof(old.arch));
> > +
> 
> Is new->arch not initialized before this function is called? Does this
> need to be here, or could it be moved above into the first branch of
> the if statement?
> Oh I see you removed the memset below and replaced it with this. I
> think this is fine, but it might be easier to reason about if we left
> the memset and moved the memcopy into the if.
> No point in doing a memcpy of zeros here.

Hmm, good point.  I wrote it like this so that the "arch" part is more identifiable
since that's what needs to be protected by the lock, but I completely agree that
it's odd when viewed without that lens.
