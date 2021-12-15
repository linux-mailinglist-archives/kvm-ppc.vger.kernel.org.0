Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15913474F69
	for <lists+kvm-ppc@lfdr.de>; Wed, 15 Dec 2021 01:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhLOApQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 14 Dec 2021 19:45:16 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:34951 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbhLOApP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 14 Dec 2021 19:45:15 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JDGk23nZqz4xd4;
        Wed, 15 Dec 2021 11:45:14 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
In-Reply-To: <20210901084512.1658628-1-aik@ozlabs.ru>
References: <20210901084512.1658628-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel] KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots
Message-Id: <163952881326.928111.10777487820265480047.b4-ty@ellerman.id.au>
Date:   Wed, 15 Dec 2021 11:40:13 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 1 Sep 2021 18:45:12 +1000, Alexey Kardashevskiy wrote:
> The userspace can trigger "vmalloc size %lu allocation failure: exceeds
> total pages" via the KVM_SET_USER_MEMORY_REGION ioctl.
> 
> This silences the warning by checking the limit before calling vzalloc()
> and returns ENOMEM if failed.
> 
> This does not call underlying valloc helpers as __vmalloc_node() is only
> exported when CONFIG_TEST_VMALLOC_MODULE and __vmalloc_node_range() is not
> exported at all.
> 
> [...]

Applied to powerpc/next.

[1/1] KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots
      https://git.kernel.org/powerpc/c/511d25d6b789fffcb20a3eb71899cf974a31bd9d

cheers
