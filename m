Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2015BDBD
	for <lists+kvm-ppc@lfdr.de>; Mon,  1 Jul 2019 16:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfGAOMu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Jul 2019 10:12:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728061AbfGAOMu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Jul 2019 10:12:50 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61E8Ppi180503;
        Mon, 1 Jul 2019 10:12:46 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tfkmb8gs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 10:12:45 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x61E9lH8014210;
        Mon, 1 Jul 2019 14:12:45 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 2tdym6qcbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 14:12:44 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x61ECgvJ49480050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 14:12:43 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8150C6061;
        Mon,  1 Jul 2019 14:12:42 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E301BC605A;
        Mon,  1 Jul 2019 14:12:39 +0000 (GMT)
Received: from [9.80.232.19] (unknown [9.80.232.19])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  1 Jul 2019 14:12:39 +0000 (GMT)
Subject: Re: [PATCH v3 3/9] powerpc: Introduce FW_FEATURE_ULTRAVISOR
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-4-cclaudio@linux.ibm.com>
 <20190615073600.GA24709@blackberry>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Message-ID: <990dd9d3-441a-229c-a007-817d1dd856be@linux.ibm.com>
Date:   Mon, 1 Jul 2019 11:12:38 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190615073600.GA24709@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010175
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 6/15/19 4:36 AM, Paul Mackerras wrote:
> On Thu, Jun 06, 2019 at 02:36:08PM -0300, Claudio Carvalho wrote:
>> This feature tells if the ultravisor firmware is available to handle
>> ucalls.
> Everything in this patch that depends on CONFIG_PPC_UV should just
> depend on CONFIG_PPC_POWERNV instead.  The reason is that every host
> kernel needs to be able to do the ultracall to set partition table
> entry 0, in case it ends up being run on a machine with an ultravisor.
> Otherwise we will have the situation where a host kernel may crash
> early in boot just because the machine it's booted on happens to have
> an ultravisor running.  The crash will be a particularly nasty one
> because it will happen before we have probed the machine type and
> initialized the console; therefore it will just look like the machine
> hangs for no discernable reason.

> We also need to think about how to provide a way for petitboot to know
> whether the kernel it is booting knows how to do a ucall to set its
> partition table entry.  One suggestion would be to modify
> vmlinux.lds.S to add a new PT_NOTE entry in the program header of the
> binary with (say) a 64-bit doubleword which is a bitmap indicating
> capabilities of the binary.  We would define the first bit as
> indicating that the kernel knows how to run under an ultravisor.
> When running under an ultravisor, petitboot could then look for the
> PT_NOTE and the ultravisor-capable bit in it, and if the PT_NOTE is
> not there or the bit is zero, put up a dialog warning the user that
> the kernel will probably crash early in boot, and asking for explicit
> confirmation that the user wants to proceed.


I just posted a separated RFC patch for the ELF note.

Thanks, Claudio.


>
> Paul.
>
