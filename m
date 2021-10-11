Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04A6428C9D
	for <lists+kvm-ppc@lfdr.de>; Mon, 11 Oct 2021 14:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbhJKMKA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 11 Oct 2021 08:10:00 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:54801 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhJKMJ7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 11 Oct 2021 08:09:59 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HScxp1gYzz4xqc;
        Mon, 11 Oct 2021 23:07:58 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, Will Deacon <will@kernel.org>,
        "Christopher M. Riedl" <cmr@codefail.de>,
        Paul Mackerras <paulus@samba.org>,
        David Hildenbrand <david@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, kvm-ppc@vger.kernel.org,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Hocko <mhocko@suse.com>
In-Reply-To: <20210914161712.2463458-1-ndesaulniers@google.com>
References: <20210914161712.2463458-1-ndesaulniers@google.com>
Subject: Re: [PATCH] powerpc: clean up UPD_CONSTR
Message-Id: <163395400287.4094789.4437570772722636872.b4-ty@ellerman.id.au>
Date:   Mon, 11 Oct 2021 23:06:42 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 14 Sep 2021 09:17:04 -0700, Nick Desaulniers wrote:
> UPD_CONSTR was previously a preprocessor define for an old GCC 4.9 inline
> asm bug with m<> constraints.
> 
> 
> 
> 

Applied to powerpc/next.

[1/1] powerpc: clean up UPD_CONSTR
      https://git.kernel.org/powerpc/c/2a24d80fc86bcd70c8e780078254e873ea217379

cheers
