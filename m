Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50E13A3204
	for <lists+kvm-ppc@lfdr.de>; Thu, 10 Jun 2021 19:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhFJR2b (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 10 Jun 2021 13:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhFJR2a (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 10 Jun 2021 13:28:30 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E5DC0617A6
        for <kvm-ppc@vger.kernel.org>; Thu, 10 Jun 2021 10:26:15 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a1so4413807lfr.12
        for <kvm-ppc@vger.kernel.org>; Thu, 10 Jun 2021 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=onW47ZbFH5e5HdlUoVPNuscSOQqX/2SrpfD9q95JllY=;
        b=b6hzP0YccRsWRRzU9ACpHmsFQnmYuaVTbX3pLJrVClZpmJ8BdQEY4NyzcB+e9HkDWy
         NC09VOvmFwa0/XSiTVEsk5yJuCNs+bQIW3AIZ02R9sahMKur9D08Bgr3lJ/OhJRtLD1o
         BlYEX0xLTOySTV9lBOztJD3qJAdsp/6IHVAqlgN264WrwRKJy5jiyfY2YODTbTv50eZm
         HagnQMsvfTQIbob7ncuANB6LsQf7XAFdg0eqOnkqhq7Zz2bDCxMdB+xv1sthskhngNbZ
         UBLuUJ4UMHWPJP6okHwkretFYjIcBoI+l5AuDgK1Gl+KtZaAOhvO85V10T2j4GFhFYmw
         bEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=onW47ZbFH5e5HdlUoVPNuscSOQqX/2SrpfD9q95JllY=;
        b=KIBo+w7Shx0EU+44tRoLaC5IaORphBTc9S98za4JeKh8l200FCp84RcJz9UrtwqhvP
         yZ41IlDbKkqi1etoE1A2AFG/KfxiBQEnSa6C1uKodDBoG11vQVVFrDX/1MYaGJJqH7lZ
         /MJwXWRCiHfrS8nr0fRyq8SjpsfPCL6cJ7v2MFkRRUl6deWKg0YPEqjgtRBPlNq6XpPX
         TLK81fCoRTqd1m3qCLKOgwd2tpUmxkrLMn7o4UFYQJjXAch9fpyvmbJ4dKP1cmkXqw0l
         DT6kiKjyxGEFFQSHx19dpmTs0T+wtiBzLuStXFRB81l6ApOfmEGmUNDCC3179SW050q+
         BMkQ==
X-Gm-Message-State: AOAM531m2gm9+PpSaoVxe9DdnG60kHSPAIH5/WpB5BARYfGQbkAOdWzK
        Zim1B9Lva8aO4naQvIof5JbIqzgoprxBFLBWhh/Pdg==
X-Google-Smtp-Source: ABdhPJz8EC2IEZhB34cW1A4E6Lqer1JPVsXnD5iNMnq9sh79Ry5VJrolXUt5s8cOLAUMW6xiM1HrMzx1A5MFg25P0eQ=
X-Received: by 2002:a05:6512:3ea:: with SMTP id n10mr2582051lfq.178.1623345973683;
 Thu, 10 Jun 2021 10:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-3-jingzhangos@google.com> <e3b2b3ab-88a2-827c-7775-10be63158ff3@redhat.com>
In-Reply-To: <e3b2b3ab-88a2-827c-7775-10be63158ff3@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 10 Jun 2021 12:26:01 -0500
Message-ID: <CAAdAUtg638Fk9QVAdZ0Xt96YS311KCfeJqNiP5FycCMafZ3R0A@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] KVM: stats: Add fd-based API to read binary stats data
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
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
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Paolo,

On Thu, Jun 10, 2021 at 11:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/06/21 23:14, Jing Zhang wrote:
> > +#define DEFINE_VM_STATS_DESC(...) {                                         \
> > +     STATS_DESC_COUNTER("remote_tlb_flush"),                                \
> > +     ## __VA_ARGS__                                                         \
> > +}
> > +
> > +#define DEFINE_VCPU_STATS_DESC(...) {                                               \
> > +     STATS_DESC_COUNTER("halt_successful_poll"),                            \
> > +     STATS_DESC_COUNTER("halt_attempted_poll"),                             \
> > +     STATS_DESC_COUNTER("halt_poll_invalid"),                               \
> > +     STATS_DESC_COUNTER("halt_wakeup"),                                     \
> > +     STATS_DESC_TIME_NSEC("halt_poll_success_ns"),                          \
> > +     STATS_DESC_TIME_NSEC("halt_poll_fail_ns"),                             \
> > +     ## __VA_ARGS__                                                         \
>
> Let's instead put this (note it's without braces) in macros like these
>
> #define KVM_GENERIC_VM_STATS()                                                  \
>         STATS_DESC_COUNTER("remote_tlb_flush"),
>
> #define KVM_GENERIC_VCPU_STATS(...)                                             \
>         STATS_DESC_COUNTER("halt_successful_poll"),                             \
>         STATS_DESC_COUNTER("halt_attempted_poll"),                              \
>         STATS_DESC_COUNTER("halt_poll_invalid"),                                \
>         STATS_DESC_COUNTER("halt_wakeup"),                                      \
>         STATS_DESC_TIME_NSEC("halt_poll_success_ns"),                           \
>         STATS_DESC_TIME_NSEC("halt_poll_fail_ns"),
>
> and it can be used in the arch files.  In fact it can even be added in patch 1 and
> switched to STATS_DESC_* here.
>
> Paolo
>
Sure, will do.

Thank,s
Jing
