Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392463644A8
	for <lists+kvm-ppc@lfdr.de>; Mon, 19 Apr 2021 15:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240184AbhDSNa4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 19 Apr 2021 09:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242396AbhDSN14 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 19 Apr 2021 09:27:56 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0D4C06135D
        for <kvm-ppc@vger.kernel.org>; Mon, 19 Apr 2021 06:26:23 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 12so55756416lfq.13
        for <kvm-ppc@vger.kernel.org>; Mon, 19 Apr 2021 06:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NqBtQukzUcKGvmZ1aJArxdkZjllZ69uT8+WTmwdJ6G4=;
        b=em/J+S9hHzBCCI9MSW7xxROUGoj1ECCpWbKbkDd7uZveF8DcpPGfSfeXe7udqDYAGS
         Jj37aD7VWJOTXi/3DhMCYdi9pJNW7jm5Sf4PAqzlM+s1im59ujQ9g0r3tX6QKiCnqI8I
         oO5sYxp5JVgxN3n4uVwCg7nst4zKPgyNiqk71xh9fzEU1SJZSiHV0spwlLta2FppoNXt
         4Sn69HhmbhTj4I1GZVCwzi8/H+Q2tBi5gcCNkX4caIusJ3tMJ1W1hCmiVohKi/6R3p1P
         P4SE3XIUdcjPLBQZiKpeMRryN/1muaULpqJ4vS3LQj+EtgGFUJ9LyQpWIyR+n0cbkMPO
         AGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NqBtQukzUcKGvmZ1aJArxdkZjllZ69uT8+WTmwdJ6G4=;
        b=NKj424tQXiTqNcoO4IOzHG8orNFmAAfkWjoPve3+jDxCX8juT0FEOvx+depTKAETU7
         NaIaG/nLCF3bj3VQQiMs/DmpDiJPnYbbmbKA8Ty6fVlv0KOHsXsTli6xlj8w40yq9YkX
         ViTF4Osuy8etQ9U7inYUZ7E1OstP24u8WE+fqVHNPXzYOWy6IANhoQ1puXuTZ1iiLcaJ
         GSLDFb9Xy3wWe2ifx9ey0yldNkOMEFCrrBgww0VLMIUv/PLLlG4rG+1vbjRJowRNTUWu
         JMk6zvNvsWgKevb//tNYIIf9VeAcl49Sd/ZXdny6B79gH82GqxAvKCsIh5Z1/6dWAfXh
         Ek+g==
X-Gm-Message-State: AOAM531c3K+ipR1JcUl4RdbCtJNUtyWd/E6EmF1Mnis7vgIK5wxl+x/4
        VlvKLElETBZyKRsyf7wEvUl9iBaF9CiB61smErsK2b5K2LUuig==
X-Google-Smtp-Source: ABdhPJzC7C637Xaczt8wN5cywlsLikI7xQQerJcl2++bY+AQeL59litpEy9MDacIxAURgyTiZJG8O4odjR7fc14+zi0=
X-Received: by 2002:a19:3813:: with SMTP id f19mr5725327lfa.473.1618838781799;
 Mon, 19 Apr 2021 06:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210415151741.1607806-1-jingzhangos@google.com>
 <20210415151741.1607806-5-jingzhangos@google.com> <9f2a8873-c2c2-ec84-58b4-7c90c59d1d25@redhat.com>
In-Reply-To: <9f2a8873-c2c2-ec84-58b4-7c90c59d1d25@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 19 Apr 2021 08:26:09 -0500
Message-ID: <CAAdAUtinT2+kqV7ia+gVFpy=Mf5TiNJU2QNSbGGC0Ybj3PPuzw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: selftests: Add selftest for KVM statistics
 data binary interface
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Emanuele,

On Mon, Apr 19, 2021 at 6:18 AM Emanuele Giuseppe Esposito
<eesposit@redhat.com> wrote:
>
> Hi Jing,
>
> > +int vm_stats_test(struct kvm_vm *vm)
> > +{
> > +     ssize_t ret;
> > +     int i, stats_fd, err = -1;
> > +     size_t size_desc, size_data = 0;
> > +     struct kvm_stats_header header;
> > +     struct kvm_stats_desc *stats_desc, *pdesc;
> > +     struct kvm_vm_stats_data *stats_data;
> > +
> > +     // Get fd for VM stats
>
> Another small nitpick: comments should go in /* */ format
Thanks. Will fix all comments.
>
> Thank you,
> Emanuele
>

Jing
