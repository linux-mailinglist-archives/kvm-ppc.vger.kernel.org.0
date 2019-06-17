Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08018479B9
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 07:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbfFQFi7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 01:38:59 -0400
Received: from ozlabs.org ([203.11.71.1]:35451 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfFQFi7 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Jun 2019 01:38:59 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45S0Ps4DC5z9s7h; Mon, 17 Jun 2019 15:38:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560749937; bh=jR54jSADlnieO8pB4/tHH0OwHqfcoZjTjfV+h+EHZcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q8UH+np3k8PiZHUFh7G7kdpoPLQbqzVVldUzKvRzM9Z/EajwRjN2hZ2E6c59i+z0U
         xw12GhPxmJJ2LtmUd092wbw2V7mKpw/vb947ObuutVzuQX26xmCgKUi9wwW7u8aB5S
         dfwNpEeMUWNE8ERsyrMYTlhTtKuoZhh4NTvpFUKWB6uJqP5BhEaT+gG3Ky4VKhNUS2
         RDIjOe7x8YX3Tig3IxavQsVxhxPHJmU695FHZ6Ui1rwWzb2eBrAAZbz0idza3oGz1Q
         4I+lDT1c5EFyFGr4CnunnCKs+lknH2cmXDt1iWSy2Y22pgeO8fTSTVOmuDbcrGLSpq
         5VwSiRkpYsAyg==
Date:   Mon, 17 Jun 2019 15:38:54 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v4 4/6] kvmppc: Handle memory plug/unplug to secure VM
Message-ID: <20190617053854.5niyzcrxeee7vvra@oak.ozlabs.ibm.com>
References: <20190528064933.23119-1-bharata@linux.ibm.com>
 <20190528064933.23119-5-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528064933.23119-5-bharata@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, May 28, 2019 at 12:19:31PM +0530, Bharata B Rao wrote:
> Register the new memslot with UV during plug and unregister
> the memslot during unplug.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
