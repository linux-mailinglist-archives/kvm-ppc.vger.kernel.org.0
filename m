Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F6474F68
	for <lists+kvm-ppc@lfdr.de>; Wed, 15 Dec 2021 01:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhLOApP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 14 Dec 2021 19:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbhLOApP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 14 Dec 2021 19:45:15 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B60C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 14 Dec 2021 16:45:15 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JDGjz73kyz4xRB;
        Wed, 15 Dec 2021 11:45:11 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
In-Reply-To: <20210901084550.1658699-1-aik@ozlabs.ru>
References: <20210901084550.1658699-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel] KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST
Message-Id: <163952881392.928111.6712272924823006428.b4-ty@ellerman.id.au>
Date:   Wed, 15 Dec 2021 11:40:13 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 1 Sep 2021 18:45:50 +1000, Alexey Kardashevskiy wrote:
> H_COPY_TOFROM_GUEST is an hcall for an upper level VM to access its nested
> VMs memory. The userspace can trigger WARN_ON_ONCE(!(gfp & __GFP_NOWARN))
> in __alloc_pages() by constructing a tiny VM which only does
> H_COPY_TOFROM_GUEST with a too big GPR9 (number of bytes to copy).
> 
> This silences the warning by adding __GFP_NOWARN.
> 
> [...]

Applied to powerpc/next.

[1/1] KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST
      https://git.kernel.org/powerpc/c/792020907b11c6f9246c21977cab3bad985ae4b6

cheers
