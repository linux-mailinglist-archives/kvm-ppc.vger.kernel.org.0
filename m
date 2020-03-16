Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87A4187217
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 19:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732211AbgCPSRK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 14:17:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43564 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732194AbgCPSRJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 14:17:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id l13so15053891qtv.10
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Mar 2020 11:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AU4sqxSt8W/YsMvcQ8X78B/FW1vBaCpl1FUzRCmrWTk=;
        b=I9kqfk62E7dF323PFh8XunJgdu4qpFvAS1l8ZUCl9A3tutXPqvJqbKiNe+tj0C59gy
         UvZhzm6L+Jz5auSW0YMh4Vg0v7FYOXZVRAu/O8ObdMAqlJuBwg3DLVpLfshmoOUlVf7h
         cpQdspxu4AQfJGqhUDxSStM+eXObVvC/uIh29hn6KdWAl4c/T4zmpRf1yXWZ2dOFtWpH
         hP7CJ2DDVAigxfpsHWrpdwyo/lwkqS4ojrnmbxom8dGEOjRhtpaC8taoW6+yOvvHDlZq
         4Jbtk6mowDdh1CCy3Nz3yEpp7X0Ml+vcVwbFmHaDPFmmHRa9qVw2l0UQ2c8gxyhWQGTb
         8NBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AU4sqxSt8W/YsMvcQ8X78B/FW1vBaCpl1FUzRCmrWTk=;
        b=UTZWNx69sQEWGknAz2hafGYbSI7krv4PdLqv8vswEYuCDAtfTzEuhoRpnfMf2/w4ai
         3ToCoUr01nZ2KlREpSm6KpofJcEvB7aZ2gNmUzUwRkpvuZtIwswqpeCiajSk/HHMzWfe
         fAd5i54tJfeAnmneUDTS8GP37nVhYART0d3u/od8Eqxe/OtrV17wkAY51BCeJsXYvXC8
         2ay679wtouuCFUs6MDNZsWmM81MZ86VYU+G2i5BbIMdE7QqH6/ftLaY2RXkYgpusf4to
         MrErHmdTKZqSUT4ucOD/k5ycpGDLDX8sgjSM/TPmw5TWMJNpYfwMEiFDVWEWmIioJpoy
         WNbA==
X-Gm-Message-State: ANhLgQ0VG5bJ9mwq6bPsNplyPKEocRzZyozIlPI4ulxUA2JdqOZDdmS6
        biq5e5/O3BnxzUHIJEF5LVKoeQ==
X-Google-Smtp-Source: ADFU+vufKXH4Rg2LSzA+eIE14Uk1GaxDUelHZyHwAwMBTplSLIhENSdd8YqSQW0Vquak3WGfZNoxUw==
X-Received: by 2002:ac8:6d19:: with SMTP id o25mr1435634qtt.303.1584382628623;
        Mon, 16 Mar 2020 11:17:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id l4sm297388qkc.26.2020.03.16.11.17.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Mar 2020 11:17:08 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jDuIV-0005TT-IP; Mon, 16 Mar 2020 15:17:07 -0300
Date:   Mon, 16 Mar 2020 15:17:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm: handle multiple owners of device private pages
 in migrate_vma
Message-ID: <20200316181707.GJ20941@ziepe.ca>
References: <20200316175259.908713-1-hch@lst.de>
 <20200316175259.908713-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316175259.908713-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 06:52:58PM +0100, Christoph Hellwig wrote:
> Add a new opaque owner field to struct dev_pagemap, which will allow
> the hmm and migrate_vma code to identify who owns ZONE_DEVICE memory,
> and refuse to work on mappings not owned by the calling entity.

Using a pointer seems like a good solution to me.

Is this a bug fix? What is the downside for migrate on pages it
doesn't work? I'm not up to speed on migrate..

Jason
