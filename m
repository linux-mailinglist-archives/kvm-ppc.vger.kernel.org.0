Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55D3399A3
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Mar 2021 23:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbhCLW1u (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Mar 2021 17:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbhCLW1W (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 12 Mar 2021 17:27:22 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CB6C061762
        for <kvm-ppc@vger.kernel.org>; Fri, 12 Mar 2021 14:27:21 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id y1so9224756ljm.10
        for <kvm-ppc@vger.kernel.org>; Fri, 12 Mar 2021 14:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUE5cPRj82pN6oWDtfrTyERGHLKsQg6bLu9MJ6uTUso=;
        b=FNFco3tIosoTdAF0Wn5QZPLnndHLHfuu5ZjcTO4lddmc1BnCcft1kp1aq/gnNi98u1
         6ZLzdR+j6/KGh5DyWwV10oNbY+qwOhlcOgMhbTJcEMifuqfrn7mh90a7E9YcI+K+aDgn
         KZnD7ROKB5mN+d5Xld1AF6bwLayt8U/qx5SnZo2lcsY6WC34s18HysDE9eTziUSQ+sbo
         0h31Me02VhrNbF9WI6eLeeoAdWAqWqYNdaWNj4Io9yrKEIr7HTSDIY1UJhRkxy0ap+0+
         8MuZ0nNKyhnmK0apDZEm1gQh9uNUldn+69B59Wm6GXYhMvpwkC+Dw8Kaz6pUf8K3ve1H
         wMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUE5cPRj82pN6oWDtfrTyERGHLKsQg6bLu9MJ6uTUso=;
        b=npAdIskE4MiBOBmZ/V9yqQaxgZ2SOz3dkQbYZuEt60uujNoSD9m8GV9TC8PauV/VRO
         x7pLvFyQS2y1yQpGdt45Aky0T+54ANVKS0yZHiNC+B9j+hb0Z7irSle/6Ti+F9uDzG+d
         LWnjf6wNWkCYYsMQtzWMKKHKKRzUIdvITNOOWnrkDUmXmv6wNE3Pn/pRDk37076fwVet
         NV5Si/DjHB/e7xmTOj+7BeBlXRNN3+ewCSBgJdhQpheKS5tyCFWn9qk2Qf57lje/6VIm
         I/x5piptgD8VegSDZfSmRpmAKkfVa2Upl3zogUSXy+0A//qp1i3Uz/yzLHF7YcMElxYm
         UTDw==
X-Gm-Message-State: AOAM530UpqKwIU/DKAMv8om6nc3lZNhgVaEIiBAhp4IykoaxTxQxkENZ
        eeXkJQXLdK48dOXOmDv9/7AJ1K2sAdmFI28EhygEhA==
X-Google-Smtp-Source: ABdhPJypcdjl26p+Fe6F+oyWMPjaNvoNfDYHRTkKiolYtZzG0+rkKu8Hda3ErL9OGzBCmPJ4OLdg2Yr71f2cJ/NFeoU=
X-Received: by 2002:a2e:8e75:: with SMTP id t21mr3678642ljk.216.1615588039907;
 Fri, 12 Mar 2021 14:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com> <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
 <CAAdAUtjj52+cAhD4KUzAaqrMSJXHD0g=ecQNG-a92Mqn3BCxiQ@mail.gmail.com> <ac7462de-1531-5428-5dca-4e3dfb897000@redhat.com>
In-Reply-To: <ac7462de-1531-5428-5dca-4e3dfb897000@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 12 Mar 2021 16:27:08 -0600
Message-ID: <CAAdAUtjV67hx5BAd31-RG6tjgfZ6tdyu_yLhkbR0d-3qm59mMA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVM ARM <kvmarm@lists.cs.columbia.edu>,
        Linux MIPS <linux-mips@vger.kernel.org>,
        KVM PPC <kvm-ppc@vger.kernel.org>,
        Linux S390 <linux-s390@vger.kernel.org>,
        Linux kselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
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

Hi Paolo,

On Fri, Mar 12, 2021 at 12:11 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/03/21 22:41, Jing Zhang wrote:
> >> I would prefer a completely different interface, where you have a file
> >> descriptor that can be created and associated to a vCPU or VM (or even
> >> to /dev/kvm).  Having a file descriptor is important because the fd can
> >> be passed to a less-privileged process that takes care of gathering the
> >> metrics
> > Separate file descriptor solution is very tempting. We are still considering it
> > seriously. Our biggest concern is that the metrics gathering/handling process
> > is not necessary running on the same node as the one file descriptor belongs to.
> > It scales better to pass metrics data directly than to pass file descriptors.
>
> If you want to pass metrics data directly, you can just read the file
> descriptor from your VMM, just like you're using the ioctls now.
> However the file descriptor also allows a privilege-separated same-host
> interface.
It makes sense.
>
> >> 4 bytes flags (always zero)
Could you give some potential use for this flag?
> >> 4 bytes number of statistics
> >> 4 bytes offset of the first stat description
> >> 4 bytes offset of the first stat value
> >> stat descriptions:
> >>    - 4 bytes for the type (for now always zero: uint64_t)
Potential use for this type? Should we move this outside descriptor? Since
all stats probably have the same size.
> >>    - 4 bytes for the flags (for now always zero)
Potential use for this flag?
> >>    - length of name
> >>    - name
> >> statistics in 64-bit format
> >
> > The binary format presented above is very flexible. I understand why it is
> > organized this way.
> > In our situation, the metrics data could be pulled periodically as short as
> > half second. They are used by different kinds of monitors/triggers/alerts.
> > To enhance efficiency and reduce traffic caused by metrics passing, we
> > treat all metrics info/data as two kinds. One is immutable information,
> > which doesn't change in a given system boot. The other is mutable
> > data (statistics data), which is pulled/transferred periodically at a high
> > frequency.
>
> The format allows to place the values before the descriptions.  So you
> could use pread to only read the first part of the file descriptor, and
> the file_operations implementation would then skip the work of building
> the immutable data.  It doesn't have to be implemented from the
> beginning like that, but the above format supports it.
Good point! I'll be working on the new fd-based interface and come back
with new patchset.
>
> Paolo
>
Thanks,
Jing
