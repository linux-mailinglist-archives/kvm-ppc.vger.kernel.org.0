Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7A64008E2
	for <lists+kvm-ppc@lfdr.de>; Sat,  4 Sep 2021 03:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350757AbhIDBDc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 3 Sep 2021 21:03:32 -0400
Received: from ozlabs.org ([203.11.71.1]:36089 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350743AbhIDBDb (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 3 Sep 2021 21:03:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4H1bwx2hyGz9sCD;
        Sat,  4 Sep 2021 11:02:25 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Leonardo Bras <leobras.c@gmail.com>, kvm-ppc@vger.kernel.org
In-Reply-To: <20210827040706.517652-1-aik@ozlabs.ru>
References: <20210827040706.517652-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel] KVM: PPC: Fix clearing never mapped TCEs in realmode
Message-Id: <163071729187.1779947.11008244687916528145.b4-ty@ellerman.id.au>
Date:   Sat, 04 Sep 2021 11:01:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 27 Aug 2021 14:07:06 +1000, Alexey Kardashevskiy wrote:
> Since e1a1ef84cd07, pages for TCE tables for KVM guests are allocated
> only when needed. This allows skipping any update when clearing TCEs.
> This works mostly fine as TCE updates are handled when MMU is enabled.
> The realmode handlers fail with H_TOO_HARD when pages are not yet
> allocated except when clearing a TCE in which case KVM prints a warning
> but proceeds to dereference a NULL pointer which crashes the host OS.
> 
> [...]

Applied to powerpc/next.

[1/1] KVM: PPC: Fix clearing never mapped TCEs in realmode
      https://git.kernel.org/powerpc/c/1d78dfde33a02da1d816279c2e3452978b7abd39

cheers
