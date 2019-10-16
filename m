Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5894DDA2FB
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Oct 2019 03:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391796AbfJQBU0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Oct 2019 21:20:26 -0400
Received: from 11.mo4.mail-out.ovh.net ([46.105.34.195]:59394 "EHLO
        11.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389550AbfJQBU0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 16 Oct 2019 21:20:26 -0400
X-Greylist: delayed 12963 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2019 21:20:25 EDT
Received: from player759.ha.ovh.net (unknown [10.108.42.239])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id E4D2220B3E2
        for <kvm-ppc@vger.kernel.org>; Wed, 16 Oct 2019 23:44:20 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player759.ha.ovh.net (Postfix) with ESMTPSA id 56850B179636;
        Wed, 16 Oct 2019 21:44:06 +0000 (UTC)
Date:   Wed, 16 Oct 2019 23:44:03 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/6] KVM: PPC: Book3S: HV: XIVE: Allocate less VPs in
 OPAL
Message-ID: <20191016234403.77cdf150@bahia.lan>
In-Reply-To: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
References: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 10318872647401970107
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdduieekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 27 Sep 2019 13:53:32 +0200
Greg Kurz <groug@kaod.org> wrote:

> This brings some fixes and allows to start more VMs with an in-kernel
> XIVE or XICS-on-XIVE device.
> 
> Changes since v1 (https://patchwork.ozlabs.org/cover/1166099/):
> - drop a useless patch
> - add a patch to show VP ids in debugfs
> - update some changelogs
> - fix buggy check in patch 5
> - Cc: stable 
> 
> --
> Greg
> 
> ---
> 
> Greg Kurz (6):
>       KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated
>       KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use
>       KVM: PPC: Book3S HV: XIVE: Show VP id in debugfs
>       KVM: PPC: Book3S HV: XIVE: Compute the VP id in a common helper
>       KVM: PPC: Book3S HV: XIVE: Make VP block size configurable
>       KVM: PPC: Book3S HV: XIVE: Allow userspace to set the # of VPs
> 
> 
>  Documentation/virt/kvm/devices/xics.txt |   14 +++
>  Documentation/virt/kvm/devices/xive.txt |    8 ++
>  arch/powerpc/include/uapi/asm/kvm.h     |    3 +
>  arch/powerpc/kvm/book3s_xive.c          |  142 ++++++++++++++++++++++++-------
>  arch/powerpc/kvm/book3s_xive.h          |   17 ++++
>  arch/powerpc/kvm/book3s_xive_native.c   |   40 +++------
>  6 files changed, 167 insertions(+), 57 deletions(-)
> 

Ping ?

Cheers,

--
Greg
