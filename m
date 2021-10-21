Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DD1435FF7
	for <lists+kvm-ppc@lfdr.de>; Thu, 21 Oct 2021 13:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhJULKs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 21 Oct 2021 07:10:48 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:33565 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJULKo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 21 Oct 2021 07:10:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HZl8W4ks0z4xbL;
        Thu, 21 Oct 2021 22:08:27 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, npiggin@gmail.com
In-Reply-To: <20211020094826.3222052-1-mpe@ellerman.id.au>
References: <20211020094826.3222052-1-mpe@ellerman.id.au>
Subject: Re: [PATCH] powerpc/idle: Don't corrupt back chain when going idle
Message-Id: <163481446090.3437586.5094721778895983974.b4-ty@ellerman.id.au>
Date:   Thu, 21 Oct 2021 22:07:40 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 20 Oct 2021 20:48:26 +1100, Michael Ellerman wrote:
> In isa206_idle_insn_mayloss() we store various registers into the stack
> red zone, which is allowed.
> 
> However inside the IDLE_STATE_ENTER_SEQ_NORET macro we save r2 again,
> to 0(r1), which corrupts the stack back chain.
> 
> We used to do the same in isa206_idle_insn_mayloss() itself, but we
> fixed that in 73287caa9210 ("powerpc64/idle: Fix SP offsets when saving
> GPRs"), however we missed that the macro also corrupts the back chain.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/idle: Don't corrupt back chain when going idle
      https://git.kernel.org/powerpc/c/496c5fe25c377ddb7815c4ce8ecfb676f051e9b6

cheers
