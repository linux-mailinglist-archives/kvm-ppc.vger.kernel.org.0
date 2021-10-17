Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CD84308A4
	for <lists+kvm-ppc@lfdr.de>; Sun, 17 Oct 2021 14:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhJQMaf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 17 Oct 2021 08:30:35 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:56437 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245634AbhJQMae (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 17 Oct 2021 08:30:34 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HXK6c3Tp6z4xqS;
        Sun, 17 Oct 2021 23:28:24 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, npiggin@gmail.com
In-Reply-To: <20211015133929.832061-1-mpe@ellerman.id.au>
References: <20211015133929.832061-1-mpe@ellerman.id.au>
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()
Message-Id: <163447368720.1156783.501192294196883402.b4-ty@ellerman.id.au>
Date:   Sun, 17 Oct 2021 23:28:07 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, 16 Oct 2021 00:39:28 +1100, Michael Ellerman wrote:
> In commit 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in
> C") kvm_start_guest() became idle_kvm_start_guest(). The old code
> allocated a stack frame on the emergency stack, but didn't use the
> frame to store anything, and also didn't store anything in its caller's
> frame.
> 
> idle_kvm_start_guest() on the other hand is written more like a normal C
> function, it creates a frame on entry, and also stores CR/LR into its
> callers frame (per the ABI). The problem is that there is no caller
> frame on the emergency stack.
> 
> [...]

Applied to powerpc/fixes.

[1/2] KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()
      https://git.kernel.org/powerpc/c/9b4416c5095c20e110c82ae602c254099b83b72f
[2/2] KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest
      https://git.kernel.org/powerpc/c/cdeb5d7d890e14f3b70e8087e745c4a6a7d9f337

cheers
