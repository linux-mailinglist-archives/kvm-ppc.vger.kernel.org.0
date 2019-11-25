Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A471086BC
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Nov 2019 04:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKYDKM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 24 Nov 2019 22:10:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726910AbfKYDKM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 24 Nov 2019 22:10:12 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAP37DWp027300
        for <kvm-ppc@vger.kernel.org>; Sun, 24 Nov 2019 22:10:10 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wfju7he62-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sun, 24 Nov 2019 22:10:10 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Mon, 25 Nov 2019 03:10:08 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 25 Nov 2019 03:10:04 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAP3A3JD34209892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 03:10:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BEAF52052;
        Mon, 25 Nov 2019 03:10:03 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.39])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 1987052050;
        Mon, 25 Nov 2019 03:10:00 +0000 (GMT)
Date:   Mon, 25 Nov 2019 08:39:58 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org
Cc:     paulus@au1.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        jglisse@redhat.com, cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de,
        Paul Mackerras <paulus@ozlabs.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v11 1/7] mm: ksm: Export ksm_madvise()
Reply-To: bharata@linux.ibm.com
References: <20191125030631.7716-1-bharata@linux.ibm.com>
 <20191125030631.7716-2-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125030631.7716-2-bharata@linux.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19112503-0020-0000-0000-0000038E508A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112503-0021-0000-0000-000021E497E5
Message-Id: <20191125030958.GD23438@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-24_04:2019-11-21,2019-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=836
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911250027
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 25, 2019 at 08:36:25AM +0530, Bharata B Rao wrote:
> On PEF-enabled POWER platforms that support running of secure guests,
> secure pages of the guest are represented by device private pages
> in the host. Such pages needn't participate in KSM merging. This is
> achieved by using ksm_madvise() call which need to be exported
> since KVM PPC can be a kernel module.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>

Just want to point out that I observe a kernel crash when KSM is
dealing with device private pages. More details about the crash here:

https://lore.kernel.org/linuxppc-dev/20191115141006.GA21409@in.ibm.com/

Regards,
Bharata.

